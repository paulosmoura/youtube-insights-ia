-- 1. Criação da nova tabela
CREATE TABLE public.vw_dim_linguagem (
    video_language TEXT PRIMARY KEY,
    idioma TEXT NOT NULL,
    regiao TEXT NOT NULL
);

-- 2. Inserção de todos os mapeamentos atualizados
INSERT INTO public.vw_dim_linguagem (video_language, idioma, regiao)
VALUES
-- Inglês
('en',     'Inglês', 'Global'),
('en-US',  'Inglês', 'EUA'),
('en-GB',  'Inglês', 'Reino Unido'),
('en-CA',  'Inglês', 'Canadá'),

-- Português
('pt',     'Português', 'Portugual'),
('pt-BR',  'Português', 'Brasil'),

-- Espanhol
('es',     'Espanhol', 'América Latina'),
('es-419', 'Espanhol', 'América Latina'),
('es-MX',  'Espanhol', 'México'),
('es-ES',  'Espanhol', 'Espanha'),
('es-US',  'Espanhol', 'Estados Unidos'),

-- Francês
('fr',     'Francês', 'França'),
('fr-FR',  'Francês', 'França'),

-- Japonês
('ja',     'Japonês', 'Japão'),

-- Hindi
('hi',       'Hindi', 'Índia'),
('hi-Latn',  'Hindi', 'Índia'),
('hi-IN',    'Hindi', 'Índia'),

-- Chinês
('zh',       'Chinês', 'China'),
('zh-CN',    'Chinês', 'China'),
('zh-Hans',  'Chinês', 'China'),
('zh-Hant',  'Chinês', 'Taiwan'),
('zh-HK',    'Chinês', 'Hong Kong'),
('zh-TW',    'Chinês', 'Taiwan'),

-- Alemão
('de',     'Alemão', 'Alemanha'),
('de-DE',  'Alemão', 'Alemanha'),
('de-CH',  'Alemão', 'Suíça'),

-- Coreano
('ko',     'Coreano', 'Coreia do Sul'),

-- Vietnamita
('vi',     'Vietnamita', 'Vietnã'),

-- Bengali
('bn',     'Bengali', 'Bangladesh'),

-- Urdu
('ur',     'Urdu', 'Paquistão'),

-- Tamil
('ta',     'Tamil', 'Índia'),

-- Telugu
('te',     'Telugu', 'Índia'),

-- Canarês
('kn',     'Canarês (Kannada)', 'Índia'),

-- Nepalês
('ne',     'Nepalês', 'Nepal'),

-- Pashto
('ps',     'Pashto', 'Afeganistão'),

-- Demais como "Outro"
('id',     'Outro', 'Outro'),
('ru',     'Russo', 'Rússia'),
('xox',    'Outro', 'Outro'),
('zxx',    'Outro', 'Outro');
