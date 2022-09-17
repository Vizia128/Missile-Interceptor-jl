# Using meters (m), seconds(s), kilograms (kg), moles (mol), Kelvin (K)
const g₀ = 9.80665      # Earth gravitational acceleration on surface (m/s)
const T₀ = 273.15       # Standard Temperature (K)
const ρ₀ = 1.2250       # Standard density at sea level (kg/m³)
const MM = 0.0289644    # Molar Mass of air (kg/mol)
const R  = 8.3144598    # Universal gas constant (N·m/(mol·K))
const Lᵣ = -0.0065      # Standard temperature lapse rate (K/m)


mutable struct Space
    dim::Vector{Float64}
    T::Float64
    ρ::Float64


end

function Space(;size = [10000.0, 10000.0, 5000.0], T = T₀, ρ = ρ₀)

density(altitude) = ρ₀*(T₀ / (T₀ + altitude*Lᵣ))^(1 + (g₀*MM) / (R*Lᵣ))
density(space::Space, altitude) = space.ρ*(space.T / (space.T + altitude*Lᵣ))^(1 + (g₀*MM) / (R*Lᵣ))
density(space::Space, altitude, temperature) = space.ρ * exp((-g₀*MM*altitude) / (R*temperature))

