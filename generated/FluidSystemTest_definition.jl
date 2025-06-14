### DO NOT EDIT THIS FILE
### This file is auto-generated by the Dyad command-line compiler.
### If you edit this code it is likely to get overwritten.
### Instead, update the Dyad source code and regenerate this file


"""
   FluidSystemTest(; name, tube_area, add_inertia)

## Parameters: 

| Name         | Description                         | Units  |   Default value |
| ------------ | ----------------------------------- | ------ | --------------- |
| `tube_area`         |                          | m2  |   0.01 |
| `add_inertia`         |                          | --  |   true |
"""
@component function FluidSystemTest(; name, tube_area=0.01, add_inertia=true, medium=IsothermalCompressible(bulk_modulus=1000000000, let_gas=false))

  ### Symbolic Parameters
  __params = Any[]
  append!(__params, @parameters (medium::AbstractMedium = medium))
  append!(__params, @parameters (tube_area::Float64 = tube_area))
  append!(__params, @parameters (add_inertia::Bool = add_inertia))
  append!(__params, @parameters (tube_perimeter::Float64 = 2 * sqrt(tube_area * pi)))

  ### Variables
  __vars = Any[]

  ### Constants
  __constants = Any[]

  ### Components
  __systems = ODESystem[]
  push!(__systems, @named signal = BlockComponents.Step(height=1000000, start_time=0.5))
  push!(__systems, @named src = HydraulicComponents.BoundaryPressure(continuity__graph0=medium))
  push!(__systems, @named vol = HydraulicComponents.FixedVolume(vol=10, p0=0, continuity__graph0=medium))
  push!(__systems, @named tube = HydraulicComponents.TubeBase(area=tube_area, head_factor=1, length=50, shape_factor=64, add_inertia=add_inertia, perimeter=2 * sqrt(tube_area * pi), m_flow0=0, continuity__graph0=medium))

  ### Defaults
  __defaults = Dict()

  ### Initialization Equations
  __initialization_eqs = []

  ### Equations
  __eqs = Equation[]
  push!(__eqs, signal.y ~ src.p)
  push!(__eqs, connect(src.port, tube.port_a))
  push!(__eqs, connect(tube.port_b, vol.port))

  # Return completely constructed ODESystem
  return ODESystem(__eqs, t, __vars, __params; systems=__systems, defaults=__defaults, name, initialization_eqs=__initialization_eqs)
end
export FluidSystemTest

Base.show(io::IO, a::MIME"image/svg+xml", t::typeof(FluidSystemTest)) = print(io,
  """<div style="height: 100%; width: 100%; background-color: white"><div style="margin: auto; height: 500px; width: 500px; padding: 200px"><svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" viewBox="0 0 1000 1000"
    overflow="visible" shape-rendering="geometricPrecision" text-rendering="geometricPrecision">
      <defs>
        <filter id='red-shadow' color-interpolation-filters="sRGB"><feDropShadow dx="0" dy="0" stdDeviation="100" flood-color="#ff0000" flood-opacity="0.5"/></filter>
        <filter id='green-shadow' color-interpolation-filters="sRGB"><feDropShadow dx="0" dy="0" stdDeviation="100" flood-color="#00ff00" flood-opacity="0.5"/></filter>
        <filter id='blue-shadow' color-interpolation-filters="sRGB"><feDropShadow dx="0" dy="0" stdDeviation="100" flood-color="#0000ff" flood-opacity="0.5"/></filter>
        <filter id='drop-shadow' color-interpolation-filters="sRGB"><feDropShadow dx="0" dy="0" stdDeviation="40" flood-opacity="0.5"/></filter>
      </defs>
    
      </svg></div></div>""")
