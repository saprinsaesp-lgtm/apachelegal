-- ==========================================================
-- ApacheLegal
-- Migration 004 - Profiles & User Roles
-- ==========================================================

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

    full_name VARCHAR(200) NOT NULL,

    phone VARCHAR(50),

    avatar_url TEXT,

    is_active BOOLEAN NOT NULL DEFAULT TRUE,

    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()

);

CREATE TRIGGER trg_profiles_updated_at
BEFORE UPDATE
ON public.profiles
FOR EACH ROW
EXECUTE FUNCTION public.set_updated_at();

CREATE INDEX idx_profiles_org
ON public.profiles(organization_id);

-- ==========================================================
-- User Roles
-- ==========================================================

CREATE TABLE public.user_roles (

    user_id UUID NOT NULL
        REFERENCES public.profiles(id)
        ON DELETE CASCADE,

    role_id UUID NOT NULL
        REFERENCES public.roles(id)
        ON DELETE CASCADE,

    assigned_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    assigned_by UUID,

    PRIMARY KEY(user_id, role_id)

);

CREATE INDEX idx_user_roles_user
ON public.user_roles(user_id);

CREATE INDEX idx_user_roles_role
ON public.user_roles(role_id);

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