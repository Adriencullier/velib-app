import CoreNetworking
import DependencyInjection
import StationFinderModuleConfiguration

struct ModulesConfiguration {
    static func configureModules(container: (Registry & Resolver)) async {
        await withTaskGroup { taskGroup in
            ModulesBuilder.allCases.forEach { module in
                taskGroup.addTask {
                    await module.conf.registerDependencies(in: container)
                }
            }
        }
        await withTaskGroup { taskGroup in
            ModulesBuilder.allCases.forEach { module in
                taskGroup.addTask {
                    await module.conf.registerFactories(in: container)
                }
            }
        }
        await withTaskGroup { taskGroup in
            ModulesBuilder.allCases.forEach { module in
                taskGroup.addTask {
                    await module.conf.start(with: container)
                }
            }
        }
    }
}

fileprivate extension ModulesConfiguration {
    enum ModulesBuilder: CaseIterable {
        case networking
        case stationFinder
        
        var conf: ModuleConfiguring.Type {
            switch self {
            case .stationFinder:
                return StationFinderModuleConfiguration.self
            case .networking:
                return CoreNetworkingModuleConfiguration.self
            }
        }
    }
}
