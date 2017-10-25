interface Config {
  isProduction: boolean
  environment: ConfigEnvironment
  server: ConfigServer
  toBrowserJSON(): Config
  debug: boolean
  isDev: boolean
  revision: string
  [prop: string]: any
}

interface ConfigServer {
  features: any
  locales: any
  config: any
  [prop: string]: any
}

interface ConfigEnvironment {
  production: boolean
  name: string
  debug: boolean
  [prop: string]: any
}

interface ConsulKV {
  Key: string
  Value: string
}

export {
  Config,
  ConsulKV
}
