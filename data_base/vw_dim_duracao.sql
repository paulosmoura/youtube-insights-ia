CREATE OR REPLACE VIEW public.vw_dim_duracao AS
SELECT
  id,
  duration_sec,
  CASE
    WHEN duration_sec <= 180 THEN 'Curta'
    WHEN duration_sec <= 600 THEN 'Média'
    WHEN duration_sec <= 1800 THEN 'Longa'
    ELSE 'Muito Longa'
  END AS duracao_faixa
FROM public.videos;
