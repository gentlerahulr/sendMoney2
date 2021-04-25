import Foundation

public final class ServiceLocator {
    public static let shared = ServiceLocator()

    private var services: [ObjectIdentifier: Any] = [:]

    public func register<T>(_ service: T) {
        services[key(for: T.self)] = service
    }

    public func resolve<T>() -> T? {
        return services[key(for: T.self)] as? T
    }

    public func clear() {
        services.removeAll()
    }

    private func key<T>(for _: T.Type) -> ObjectIdentifier {
        return ObjectIdentifier(T.self)
    }
}

@propertyWrapper
public struct Injected<T> {
    private let serviceLocator: ServiceLocator

    private var _explicitValue: T?

    public init(serviceLocator: ServiceLocator = .shared) {
        self.serviceLocator = serviceLocator
    }

    public var wrappedValue: T {
        get {
            guard let value = serviceLocator.resolve() ?? _explicitValue else {
                fatalError("Service not yet registered for type \(T.self)")
            }
            return value
        }
        set {
            _explicitValue = newValue
        }
    }
}
