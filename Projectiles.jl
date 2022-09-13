
function normalize(v::MultiVector)
    if v == 0
        return v
    else
        return v / norm(v)
    end
end

function normalize(v::Chain)
    return v / norm(v)
end

function normalize!(v::MultiVector)
    v = v / norm(v)
    return v
end

function normalize!(v::Chain)
    v = v / norm(v)
    return v
end

abstract type Projectile end

mutable struct CannonBall <: Projectile
    id::Int
    pose::MultiVector
    rate::MultiVector
    inertia::MultiVector
    alive::Bool
end

function CannonBall(id::Int, pose::MultiVector; radius = 0.175/2, mass = 17.6, muzzleVelocity = 450.0)

    inertia::MultiVector = mass*(2/5*radius^2*(v₁₂ + v₁₃ + v₁₄) + 1.0v₂₃ + 1.0v₂₄ + 1.0v₃₄)

    rate::MultiVector = muzzleVelocity * normalize!(pose(2)[6]*v₁₂ + pose(2)[5]*v₁₃ + pose(2)[4]*v₁₄)
    CannonBall(id, pose, rate, inertia, true)
end


# Mortar
# length = 840mm, diameter = 155mm, mass = 46.7kg, muzzleVelocity = 827m/s
# h = 0.84; r = 0.0775; m = 46.7; v = 827;
# inertia = m*(1/12*(3r^2 + h^2)*v₁₂ + 1/12*(3r^2 + h^2)*v₁₃ + 1/2*r^2*v₁₄ + 1.0v₂₃ + 1.0v₂₄ + 1.0v₃₄)

mutable struct Mortar <: Projectile
    id::Int
    pose::MultiVector

    rate::MultiVector
    inertia::MultiVector

    alive::Bool
end

function Mortar(id::Int, pose::MultiVector; length = 0.84, radius = 0.0775, mass = 46.7, muzzleVelocity = 827.0)

    inertia::MultiVector = mass*(1/12*(3radius^2 + length^2)*(v₁₂ + v₁₃) + 1/2*radius^2*v₁₄ + 1.0v₂₃ + 1.0v₂₄ + 1.0v₃₄)
    rate::MultiVector = muzzleVelocity * normalize!(pose(2)[6]*v₁₂ + pose(2)[5]*v₁₃ + pose(2)[4]*v₁₄)

    CannonBall(id, pose, rate, inertia, true)
end


@with_kw mutable struct Rocket <: Projectile
    id::Int

    pose::MultiVector
    rate::MultiVector = 0.0v₁₂ + 0.0v₃₄
    inertia::MultiVector = 1.0v₁₂ + 1.0v₁₃ + 1.0v₁₄ + 1.0v₂₃ + 1.0v₂₄ + 1.0v₃₄

    fuel::Float64 = 0.0
    alive::Bool = true
end

@with_kw mutable struct Missile <: Projectile
    id::Int
    pose::MultiVector

    rate::MultiVector = 0.0v₁₂ + 0.0v₃₄
    inertia::MultiVector = 1.0v₁₂ + 1.0v₁₃ + 1.0v₁₄ + 1.0v₂₃ + 1.0v₂₄ + 1.0v₃₄

    fuel::Float64 = 0.0
    alive::Bool = true
end

@with_kw mutable struct Interceptor <: Projectile
    id::Int
    pose::MultiVector

    rate::MultiVector = 0.0v₁₂ + 0.0v₃₄
    inertia::MultiVector = 1.0v₁₂ + 1.0v₁₃ + 1.0v₁₄ + 1.0v₂₃ + 1.0v₂₄ + 1.0v₃₄

    fuel::Float64 = 0.0
    alive::Bool = true
end


function aeroForque(space::Space, obj::CannonBall)
    ρ = density(space, obj.pose(2)[3] / obj.pose(0)[1])
    return 0.25 * ρ * norm(obj.rate) * obj.rate
end

