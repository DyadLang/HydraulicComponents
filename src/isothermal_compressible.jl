@kwdef struct IsothermalCompressible <: AbstractMedium
  # fluid density at 0Pa reference gauge pressure `p`
  density = 997
  # Gauge pressure
  pressure = 100325
  bulk_modulus = 2e9
  bulk_modulus_gas = 1.01325e5
  # density exponent
  density_exponent = 1
  # fluid dynamic viscosity
  viscosity = 0.0010016
  # set `true` to allow fluid to transition from liquid to gas
  let_gas = true
  # density of fluid in gas state at reference gauge pressure `p_gas`
  gas_density = 0.0073955
  # reference pressure
  gas_pressure = -1000
end

function density(medium::AbstractMedium, _)
  error("This function is not defined for $medium.\n")
end

function _density(beta, density, pressure, p)
  return density * (1 + (p - pressure) / beta)
end

function density(medium::IsothermalCompressible, p)
  @unpack density, pressure, bulk_modulus, bulk_modulus_gas, density_exponent, viscosity, let_gas, gas_density, gas_pressure = medium
  return _density(ifelse(let_gas, ifelse(p > pressure, bulk_modulus, bulk_modulus_gas), bulk_modulus), density, pressure, p)
end

@register_symbolic density(medium::AbstractMedium, p)

function _pressure(beta, density, pressure, rho)
  return pressure + (1 / beta) * (rho / density - 1)
end

function pressure(medium::IsothermalCompressible, rho)
  @unpack density, pressure, bulk_modulus, bulk_modulus_gas, density_exponent, viscosity, let_gas, gas_density, gas_pressure = medium
  return _pressure(ifelse(let_gas, ifelse(rho > density, bulk_modulus, bulk_modulus_gas), bulk_modulus), density, pressure, rho)
end

@register_symbolic pressure(medium::AbstractMedium, rho)

function viscosity(medium::IsothermalCompressible)
  @unpack viscosity = medium
  return viscosity
end

@register_symbolic viscosity(medium::AbstractMedium)
