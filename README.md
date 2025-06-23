# YouTube Insights IA

## Visão Geral

Este projeto foi desenvolvido com o objetivo de identificar padrões de conteúdo e engajamento em vídeos virais sobre Inteligência Artificial (IA) no YouTube. A proposta envolve classificar vídeos automaticamente com base em critérios semânticos, intenção e linguagem, utilizando IA generativa e uma stack de automação e visualização de dados.

## Abordagem Geral

### 1. Busca de Vídeos Virais

* Um fluxo n8n é responsável por consultar a YouTube Data API com uma lista de termos em múltiplos idiomas e regiões.
* A busca prioriza vídeos com mais visualizações (parâmetro `order = viewCount`).
* Exemplo de termos:

  ```js
  { termo: "ganhar dinheiro com IA", idioma: "pt", origem: "Brasil" }
  { termo: "make money with AI", idioma: "en", origem: "EUA" }
  { termo: "AI tutorial", idioma: "en", origem: "Canadá" }
  { termo: "人工矩能", idioma: "ja", origem: "Japão" }
  ```
* O node responsável é `iniciar termos`, localizado no fluxo `ETL_FLOW_MAIN`.

### 2. Classificação via ChatGPT 3.5

Cada vídeo é classificado automaticamente com base em:

* Tipo de conteúdo (técnico, clickbait, híbrido, superficial)
* Intenção principal e secundária (educacional, comercial, opinativo etc.)
* Linguagem (neutra, alarmista, acadêmica etc.)
* Nível técnico (0.0 a 1.0)

### 3. Armazenamento no Supabase

As informações dos vídeos e classificações são salvas em tabelas relacionais (fato e dimensões).

### 4. Visualização no Power BI

Métricas de engajamento, views, canais e cruzamentos são visualizadas em painéis interativos.

## Decisão N8N vs Python para esse projeto

Apesar de ter experiência com Python e já ter desenvolvido rotinas de extração e web scraping com bibliotecas como requests, BeautifulSoup e Selenium, optei por utilizar o n8n como ferramenta de orquestração e coleta de dados neste projeto por três principais razões:

### 1. Velocidade de prototipação

O n8n permite criar e testar fluxos de extração e automação com grande rapidez, sem a necessidade de escrever código repetitivo para controle de fluxo, logging ou tratamento de erros básicos. Isso foi importante para iterar rapidamente durante o desenvolvimento inicial.

### 2. Observabilidade nativa

A interface visual do n8n facilita o monitoramento das etapas do ETL, incluindo checkpoints, tentativas automáticas, e logging customizado — o que é essencial para projetos que processam dados em lote como este.

### 3. Escalabilidade e manutenção simplificada

Por se tratar de um projeto que pode ser disparado periodicamente e operado por múltiplos usuários ou clientes, o n8n proporciona uma estrutura mais acessível e de baixo custo para manutenção e extensão futura.

## Ferramentas Utilizadas

* **n8n**: Orquestração e automação do pipeline de dados.
* **Render (versão free)**: Hospedagem do servidor n8n.
* **OpenAI ChatGPT 3.5**: Classificação semântica dos vídeos.
* **Supabase (versão free)**: Banco de dados relacional com API integrada.
* **Power BI**: Visualização de dashboards.
* **DAX Studio**: Diagnóstico e extração de métricas do Power BI.
* **Figma**: Criação visual dos painéis.

## Estrutura de Pastas

```
youtube-insights-ia/
├── data_base         # Schema e scripts do Supabase
├── dashboard         # Arquivo Power BI (.pbix)
├── paineis_figma     # Visuais dos dashboards
├── dataflow_n8n      # JSONs e documentação dos fluxos n8n
├── docs              # Prints e arquivos de apoio
└── README.md
```

## Operação do Fluxo no n8n

### Monitoramento de Erros com `ETL_ERROR_LOGS_WORKFLOW`

* Trigger global captura erros em workflows conectados via `errorWorkflow`.
* Logs registrados na tabela `etl_logs` no Supabase.
* Campos registrados: `fluxo`, `etapa`, `mensagem`, `status`, `timestamp`.

### Resiliência nos Fluxos Principais

* `ETL_FLOW_MAIN` e `ETL_IA_CLASSIFICACAO` contêm lógica para fallback e log:

  * `IF` direciona a log de "vazio" se não houver dados.
  * `IF` pós-upsert valida se houve inserção de dados.
  * Uso de `Split In Batches` com `Waits` e `Retries`.
  * Prompt da IA reforça instruções com validação semântica.

## Como Rodar

1. Clone o repositório:

   ```bash
   git clone https://github.com/paulosmoura/youtube-insights-ia.git
   ```
2. Importe os fluxos n8n de `/dataflow_n8n` , ETL_FLOW_MAIN , ETL_IA_CLASSIFICACAO e ETL_ERROR_LOGS_WORKFLOW
3. Crie as tabelas Supabase com os scripts de `/data_base`
3.1. Execute os scripts SQL em `/data_base` para criar e popular as tabelas:

```bash
psql -U postgres -d youtube_insights -f data_base/vw_dim_canal.sql
psql -U postgres -d youtube_insights -f data_base/vw_dim_duracao.sql
psql -U postgres -d youtube_insights -f data_base/fact_videos_rows.sql
psql -U postgres -d youtube_insights -f data_base/dim_classificacao_ia_rows.sql
psql -U postgres -d youtube_insights -f data_base/etl_logs_rows.sql
psql -U postgres -d youtube_insights -f data_base/vw_dim_linguagem_rows.sql
```
O script vw_dim_duracao.sql cria uma view baseada na duração (duration_sec) e aplica a seguinte categorização:

Faixa	Intervalo de tempo (s)
Curta	até 180 s
Média	181–600 s
Longa	601–1800 s
Muito Longa	acima de 1800 s

4. Configure as credenciais no N8N (OpenAI, Supabase) , não adicionei a credencial da OpenAI API KEY por questões de segurança para criar a chave, é necessário logar no site da OpenAI e gear uma chave.
5. Configure no fim do fluxo 'ETL_FLOW_MAIN' o link do webhook do 'ETL_IA_CLASSIFICACAO'.
5. Execute o fluxo `ETL_FLOW_MAIN` no fim da execução ele irá enviar um request (POST) para o outro fluxo que está configurado com um webhook.
6. Abra o `.pbix` no Power BI

## Painéis no Power BI

* Classificação de vídeos por tipo e intenção
* Engajamento médio por tipo de conteúdo
* Evolução mensal de views
* Análise por idioma, país e canal
* Painel de métricas e Objetivos de análise para facilitar o usuário final a entender as regras de negócio e o objetivo da solução

## Desempenho e Custos Estimados

O projeto roda com infraestrutura gratuita:

* **Render (free tier)**: hospeda o n8n sem custos operacionais.
* **Supabase (free tier)**: suporta o volume de dados e logging sem cobrança.

### Tempo de execução

| Etapa               | Tempo aproximado      |
| ------------------- | --------------------- |
| ETL principal (n8n) | \~14 minutos          |
| Classificação IA    | \~32 minutos e 46 seg |

### Custo de IA (OpenAI)

| Métrica     | Valor Estimado |
| ----------- | -------------- |
| Tokens      | \~1.931.000    |
| Custo (USD) | \~\$0.97       |

Esses valores são baseados em uma execução de **989 vídeos**.

O projeto pode ser parelelizado e adaptado para rodar mais vídeos.

## Melhorias Futuras

O projeto pode ser expandido com diversas melhorias que aumentam sua robustez, escalabilidade e capacidade analítica.

### 1. Enriquecimento de Localização e Região

A YouTube Data API v3 não retorna dados confiáveis sobre a origem geográfica dos vídeos. Como melhoria, sugere-se:

* Inferir a localização com base na análise de título, descrição ou comentários.
* Integrar APIs externas, como:
  * ipinfo.io (localização por IP)
  * SerpAPI ou scraping controlado de SERPs
  * Plataformas como SocialBlade para metadados de canal

### 2. Disparo Automático de Dashboards

Para ampliar a aplicabilidade do projeto:

* Automatizar o envio de dashboards em PDF por e-mail com periodicidade diária ou semanal.
* Alternativas técnicas:
  * Power BI Service + Power Automate (versão Pro)
  * Scripts Python com renderização e envio por SMTP
  * Integração via n8n com gatilho recorrente

### 3. Aprimoramento da Classificação por IA

* Substituir o modelo atual por versões mais avançadas (ex: GPT-4).
* Criar um ciclo de validação supervisionada com feedback humano.
* Incorporar critérios objetivos como análise de palavras-chave e links externos.

### 4. Monitoramento de Tendências

* Criar um módulo que detecta aumento repentino de visualizações por termo de busca.
* Utilizar Google Trends como fonte complementar para sugerir novos termos.

### 5. Métricas Avançadas de Canal e Engajamento

* Analisar o crescimento dos canais ao longo do tempo.
* Correlacionar tipos de conteúdo com variações de engajamento (likes, comentários, retenção).

### 6. Modularização e Escalabilidade

* Dividir o projeto em etapas desacopladas: extração, classificação, armazenamento e visualização.
* Viabilizar deploy com containers Docker para facilitar replicação e escalabilidade.
