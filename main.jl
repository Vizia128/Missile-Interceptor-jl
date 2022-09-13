using Agents, Parameters, GLMakie, Grassmann

basis"0,1,1,1"  # Initialize GA to PGA

include("ProjectiveGeometricSpace.jl")
include("Projectiles.jl")


space = Space()
cannon = CannonBall(1, 1.0 + 1.0v1234)


