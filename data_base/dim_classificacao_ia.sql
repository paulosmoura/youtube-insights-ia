CREATE TABLE public.dim_classificacao_ia (
  video_id TEXT REFERENCES public.videos(id),
  classificacao_desc TEXT,
  classificacao_score NUMERIC,
  linguagem TEXT,
  intencao_principal TEXT,
  intencao_secundaria TEXT,
  nivel_tecnico NUMERIC
);