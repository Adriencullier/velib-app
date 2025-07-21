protocol AllTerminalsDataSource {
    func fetchAllTerminals() async throws -> [TerminalDTO]
}
