using Agents, Parameters, Makie, Grassmann

basis"0,1,1,1"  # Initialize GA to PGA

space = ContinuousSpace((1.0, 1.0, 1.0); periodic = true)

@with_kw mutable struct Projectile <: AbstractAgent
    id::Int
    pos::NTuple{3,Float64}
    type::Symbol ## one of :rocket, :missile, :interceptor
    fuel::Float64
    alive::Bool = true

    pose::MultiVector
    rate::MultiVector
    inertia::MultiVector
end

Rocket(id, pos, energy) = Projectile(id, pos, :rocket, fuel)
Missile(id, pos, energy) = Projectile(id, pos, :missile, fuel)
Interceptor(id, pos, energy) = Projectile(id, pos, :interceptor, fuel)

