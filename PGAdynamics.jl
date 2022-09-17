

function inertiaMap(rate::Chain, inertia::Chain)
    momentum = !rate
    for (m, i) in zip(momentum[1:end], inertia[1:end])
        m = m * i
    end
    return momentum
end

function inertiaMapInv(momentum::Chain, inertia::Chain)
    rate = 0.0v₁₂ + 0.0v₁₃ + 0.0v₁₄ + 0.0v₂₃ + 0.0v₂₄ + 0.0v₃₄
    for (r, m, i) in zip(rate[1:end], momentum[1:end], inertia[1:end])
        r = m * i
    end
    return rate
end