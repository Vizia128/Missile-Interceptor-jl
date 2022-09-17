using Agents, InteractiveDynamics, GLMakie

mutable struct Missile <: AbstractAgent
    id::Int
    pos::NTuple{2, Float64}
    vel::NTuple{2, Float64}
    fuel::Float64
end

function Missile(id)
    return Missile(id, (1,1), (1,1), 100)
end

function initialize(; numMissiles = 1, spaceLen = 100)
    space = ContinuousSpace((100,100))
    model = AgentBasedModel(Missile, space)

    for m in 1:numMissiles
        agent = Missile(m)
        add_agent_pos!(agent, model)
    end

    return model
end

function agent_step!(agent, model)
    agent.pos = agent.pos .+ agent.vel
    return
end

model = initialize()
step!(model, agent_step!)

fig, _ = abm_plot(model)
display(fig)
