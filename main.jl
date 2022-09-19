using Agents, InteractiveDynamics, DifferentialEquations, GLMakie, LinearAlgebra

# Using meters (m), seconds(s), kilograms (kg), moles (mol), Kelvin (K)
const g₀ = 9.80665      # Earth gravitational acceleration on surface (m/s)
const T₀ = 273.15       # Standard Temperature (K)
const ρ₀ = 1.2250       # Standard density at sea level (kg/m³)
const MM = 0.0289644    # Molar Mass of air (kg/mol)
const R  = 8.3144598    # Universal gas constant (N·m/(mol·K))
const Lᵣ = -0.0065      # Standard temperature lapse rate (K/m)

const m = 17.6
const r = 0.175/2
const v₀ = 450.0
#θ = π/180 * 80
Cd = 0.5
const A = π*r^2

mutable struct World
    n::Int      # step number
    Δt::Float64 # time per step
end

mutable struct Missile <: AbstractAgent
    id::Int
    pos::NTuple{2, Float64}
    vel::NTuple{2, Float64}

    type::Symbol
    fuel::Float64
end

function Missile(id::Int, type::Symbol)
    return Missile(id, (0,0), (400,400), type, 100)
end

function Missile(id::Int, xpos::Real, Θ::Real, type::Symbol)
    pos = (xpos, 0)
    vel = v₀ .* (cos(Θ), sin(Θ))
    return Missile(id, pos, vel, type, 100)
end

g(altitude) = [0.0, -g₀]
ρ(altitude) = ρ₀*(T₀ / (T₀ + altitude*Lᵣ))^(1 + (g₀*MM) / (R*Lᵣ))
thrust(v, t) = t < 10 ? 100*normalize(v) : [0,0]

function drag!(du, u, p, t)
    du[:,1] = u[:,2]
    du[:,2] = [0.0, -g₀] - 0.5*A*Cd*ρ(u[2,1])*u[:,2]*norm(u[:,2]) / m
end

function initialize(; numMissiles = 2, spaceLen = 5000.)
    space = ContinuousSpace((spaceLen,spaceLen/2))
    model = AgentBasedModel(Missile, space)

    for m in 1:numMissiles
        if m%2 == 0
            agent = Missile(m, 0, π/6, :Enemy)
        else
            agent = Missile(m, 4500, 5π/6, :Ally)
        end
        #Missile(m, m%2 == 0 ? :Ally : :Enemy)
        add_agent_pos!(agent, model)
    end

    return model
end

function model_step!(model)
    model.n +=1
end

function agent_step!(agent, model)
    u0 = [collect(agent.pos) collect(agent.vel)]
    
    prob = ODEProblem(drag!, u0, (0.0, 1.0))
    sol = solve(prob; save_everystep=false, )
    
    agent.pos = Tuple(sol.u[end][:,1])
    agent.vel = Tuple(sol.u[end][:,2])
end

groupcolor(agent) = agent.type == :Ally ? :blue : :red
groupmarker(agent) = agent.type == :Ally ? :circle : :circle


model = initialize()

fig, ax, lin = abmplot(
    model;
    agent_step!, model_step! = dummystep,
    ac = groupcolor, am = groupmarker, as = 12
)
display(fig)

