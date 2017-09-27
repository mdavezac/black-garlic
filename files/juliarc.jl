let
    condition = "CURRENT_FUN_WITH_HOMEDIR" ∈ keys(ENV) &&
                "JULIA_PKGDIR" ∉ keys(ENV) &&
                isdir(joinpath(ENV["CURRENT_FUN_WITH_HOMEDIR"],
                                "julia", "v$(VERSION.major).$(VERSION.minor)"))

    if condition
        ENV["JULIA_PKGDIR"] = joinpath(ENV["CURRENT_FUN_WITH_HOMEDIR"],
                                       "julia", "v$(VERSION.major).$(VERSION.minor)")
    end
    
{%- for package in packages %}
    Pkg.installed("{{package}}") !== nothing || Pkg.add("{{package}}")
{%- endfor %}
    Pkg.installed("OhMyREPL") !== nothing && using OhMyREPL
end
@schedule begin
    sleep(0.1)
    @eval begin 
        using Revise
        colorscheme!("Monokai24bit")
    end
end
