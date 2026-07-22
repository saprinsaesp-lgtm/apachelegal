-- ==========================================================
-- ApacheLegal
-- Migration 003 - Identity (Parte 1)
-- ==========================================================

-- ============================
-- ROLES
-- ============================

CREATE TABLE public.roles (

    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    organization_id UUID NOT NULL
        REFERENCES public.organizations(id)
        ON DELETE CASCADE,

    name VARCHAR(100) NOT NULL,

    description TEXT,

    is_system BOOLEAN NOT NULL DEFAULT FALSE,

    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()

);

CREATE TRIGGER trg_roles_updated_at
BEFORE UPDATE
ON public.roles
FOR EACH ROW
EXECUTE FUNCTION public.set_updated_at();

CREATE INDEX idx_roles_org
ON public.roles(organization_id);

-- ============================
-- PERMISSIONS
-- ============================

CREATE TABLE public.permissions (

    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    code VARCHAR(150) NOT NULL UNIQUE,

    module VARCHAR(100) NOT NULL,

    description TEXT,

    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()

);

CREATE INDEX idx_permissions_module
ON public.permissions(module);