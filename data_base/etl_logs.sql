CREATE TABLE public.etl_logs (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  fluxo TEXT,
  etapa TEXT,
  status TEXT,
  mensagem TEXT,
  timestamp TIMESTAMP DEFAULT now()
);