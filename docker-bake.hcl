group "default" {
    targets = ["client-15", "client-main", "nginx-15", "nginx-main"]
}

group "client" {
    targets = ["client-15", "client-main"]
}

group "nginx" {
    targets = ["nginx-15", "nginx-main"]
}

target "_common" {
    dockerfile = "Dockerfile"
    platforms  = ["linux/amd64", "linux/arm64"]
    attest = [
        {
            type = "provenance"
            mode = "max"
        },
        {
            type = "sbom"
        }
    ]
    labels = {
        "org.opencontainers.image.source"        = "https://github.com/gmarrot/docker-psql-client"
        "org.opencontainers.image.documentation" = "https://github.com/gmarrot/docker-psql-client#readme"
        "org.opencontainers.image.url"           = "https://github.com/gmarrot/docker-psql-client"
        "org.opencontainers.image.licenses"      = "MIT"
        "org.opencontainers.image.vendor"        = "gmarrot"
    }
}

target "client-15" {
    inherits   = ["_common"]
    dockerfile = "Dockerfile.client"
    context    = "."
    tags       = ["gmarrot/postgresql-client:15"]
    args = {
        PG_VERSION     = "15"
        ALPINE_VERSION = "3.22"
    }
}

target "client-main" {
    inherits   = ["_common"]
    name       = "client-${version}"
    dockerfile = "Dockerfile.client"
    context    = "."
    tags       = ["gmarrot/postgresql-client:${version}"]
    args = {
        PG_VERSION     = version
        ALPINE_VERSION = "3.23"
    }
    matrix = {
        version = ["16", "17", "18"]
    }
}

target "nginx-15" {
    inherits   = ["_common"]
    dockerfile = "Dockerfile.nginx"
    context    = "."
    tags       = ["gmarrot/postgresql-client:15-nginx"]
    args = {
        PG_VERSION     = "15"
        NGINX_VERSION  = "1.28"
        ALPINE_VERSION = "3.22"
    }
}

target "nginx-main" {
    inherits   = ["_common"]
    name       = "nginx-${version}"
    dockerfile = "Dockerfile.nginx"
    context    = "."
    tags       = ["gmarrot/postgresql-client:${version}-nginx"]
    args = {
        PG_VERSION     = version
        NGINX_VERSION  = "1.28"
        ALPINE_VERSION = "3.23"
    }
    matrix = {
        version = ["16", "17", "18"]
    }
}
