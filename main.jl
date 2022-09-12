using Agents, Parameters, Grassmann

basis"0,1,1,1"  # Initialize to PGA


space = ContinuousSpace((1.0, 1.0, 1.0); periodic = true)

@with_kw mutable struct Projectile <: AbstractAgent
    id::Int
    pos::NTuple{3,Float64}
    type::Symbol ## one of :rocket, :missile, :interceptor
    fuel::Float64
    alive::Bool = true

    pose = 0.0 + 0.0v₁ + 0.0v₂ + 0.0v₃ + 0.0v₄ + 0.0v₁₂₃ + 0.0v₁₂₄ + 0.0v₁₃₄ + 0.0v₂₃₄ + 0.0v₁₂₃₄ # motor
    rate = 0.0v₁₂ + 0.0v₁₃ + 0.0v₁₄ + 0.0v₂₃ + 0.0v₂₄ + 0.0v₃₄  # line
    inertia = 0.0v₁₂ + 0.0v₁₃ + 0.0v₁₄ + 0.0v₂₃ + 0.0v₂₄ + 0.0v₃₄   # line
end

Rocket(id, pos, energy) = Projectile(id, pos, :rocket, fuel)
Missile(id, pos, energy) = Projectile(id, pos, :missile, fuel)
Interceptor(id, pos, energy) = Projectile(id, pos, :interceptor, fuel)
