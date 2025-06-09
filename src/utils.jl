reg_pow(x, index, delta = 1) = ifelse(x>=delta, x^index, 1/delta*x^3-x^2+delta*x)
@register_symbolic reg_pow(x, index)

function liquid_density(bulk_modulus, density, n, p)
  density * reg_pow(1 + n * p / bulk_modulus, 1 / n)
end
@register_symbolic liquid_density(bulk_modulus, density, n, p)

function gas_density_f(density, gas_density, p_gas, p)
  density + p * (density - gas_density) / (0 - p_gas)
end

@register_symbolic gas_density_f(density, gas_density, p_gas, p)

function full_density(bulk_modulus, density, gas_density, p_gas, let_gas, n)
  rho = p -> ifelse(let_gas,
    ifelse(p > 0,
      liquid_density(bulk_modulus, density, n, p),
      gas_density_f(density, gas_density, p_gas, p)),
    liquid_density(bulk_modulus, density, n, p))
  return rho
end
@register_symbolic full_density(bulk_modulus, density, gas_density, p_gas, let_gas, n)

function friction_factor(m_flow, area, d_h, viscosity, shape_factor)
  Re = abs(m_flow) * d_h / (area * viscosity)

  if Re <= 2000
      return f_laminar(shape_factor, Re)
  elseif 2000 < Re < 3000
      return transition(2000, 3000, f_laminar(shape_factor, Re),
          f_turbulent(shape_factor, Re), Re)
  else
      return f_turbulent(shape_factor, Re)
  end
end
@register_symbolic friction_factor(m_flow, area, d_h, viscosity, shape_factor)
Symbolics.derivative(::typeof(friction_factor), args, ::Val{1}) = 0
Symbolics.derivative(::typeof(friction_factor), args, ::Val{4}) = 0

function transition(x1, x2, y1, y2, x)
  u = (x - x1) / (x2 - x1)
  blend = u^2 * (3 - 2 * u)
  return (1 - blend) * y1 + blend * y2
end


f_laminar(shape_factor, Re) = shape_factor * reg_pow(Re, -1, 0.1) #reg_pow used to avoid dividing by 0, min value is 0.1
f_turbulent(shape_factor, Re) = (shape_factor / 64) / (0.79 * log(Re) - 1.64)^2
