-- ==========================================================
-- ApacheLegal
-- Migration 001 - Initial Schema
-- ==========================================================

CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- ==========================================================
-- Función para actualizar updated_at automáticamente
-- ==========================================================

CREATE OR REPLACE FUNCTION public.set_updated_at()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$;

-- ==========================================================
-- Tabla: organizations
-- ==========================================================

CREATE TABLE public.organizations (

    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    name VARCHAR(200) NOT NULL,

    legal_name VARCHAR(250),

    tax_id VARCHAR(50),

    email VARCHAR(200),

    phone VARCHAR(50),

    country VARCHAR(100) NOT NULL DEFAULT 'Colombia',

    city VARCHAR(100),

    is_active BOOLEAN NOT NULL DEFAULT TRUE,

    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()

);

CREATE TRIGGER trg_organizations_updated_at

BEFORE UPDATE ON public.organizations

FOR EACH ROW

EXECUTE FUNCTION public.set_updated_at();