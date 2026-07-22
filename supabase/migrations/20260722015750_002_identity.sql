-- ==========================================================
-- ApacheLegal
-- Migration 002 - Identity
-- ==========================================================

-- ==========================================================
-- Roles
-- ==========================================================

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
BEFORE UPDATE ON public.roles
FOR EACH ROW
EXECUTE FUNCTION public.set_updated_at();

-- ==========================================================
-- Permissions
-- ==========================================================

CREATE TABLE public.permissions (

    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    code VARCHAR(150) NOT NULL UNIQUE,

    module VARCHAR(100) NOT NULL,

    description TEXT,

    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()

);

-- ==========================================================
-- Role Permissions
-- ==========================================================

CREATE TABLE public.role_permissions (

    role_id UUID NOT NULL
        REFERENCES public.roles(id)
        ON DELETE CASCADE,

    permission_id UUID NOT NULL
        REFERENCES public.permissions(id)
        ON DELETE CASCADE,

    PRIMARY KEY(role_id, permission_id)

);

-- ==========================================================
-- Profiles
-- ==========================================================

CREATE TABLE public.profiles (

    id UUID PRIMARY KEY
        REFERENCES auth.users(id)
        ON DELETE CASCADE,

    organization_id UUID NOT NULL
        REFERENCES public.organizations(id)
        ON DELETE CASCADE,

    role_id UUID
        REFERENCES public.roles(id),

    full_name VARCHAR(200) NOT NULL,

    phone VARCHAR(50),

    avatar_url TEXT,

    is_active BOOLEAN NOT NULL DEFAULT TRUE,

    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()

);

CREATE TRIGGER trg_profiles_updated_at
BEFORE UPDATE ON public.profiles
FOR EACH ROW
EXECUTE FUNCTION public.set_updated_at();

CREATE INDEX idx_profiles_org
ON public.profiles(organization_id);

CREATE INDEX idx_profiles_role
ON public.profiles(role_id);