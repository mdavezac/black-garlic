let
    condition = "CURRENT_FUN_WITH_HOMEDIR" ∈ keys(ENV) &&
    "JULIA_PKGDIR" ∉ keys(ENV) &&
    isdir(joinpath(ENV["CURRENT_FUN_WITH_HOMEDIR"],
                    "julia", "v$(VERSION.major).$(VERSION.minor)"))

    if condition
        ENV["JULIA_PKGDIR"] = joinpath(ENV["CURRENT_FUN_WITH_HOMEDIR"],
                                       "julia", "v$(VERSION.major).$(VERSION.minor)")
    end
end
