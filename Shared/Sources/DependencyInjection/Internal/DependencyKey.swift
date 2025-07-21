struct DependencyKey: Equatable, Hashable {
    private let type: Any.Type
    
    init(_ type: Any.Type) {
        self.type = type
    }
    
    static func == (lhs: DependencyKey, rhs: DependencyKey) -> Bool {
        lhs.type == rhs.type
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(type))
    }
}
