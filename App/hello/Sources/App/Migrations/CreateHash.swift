import Vapor
import Fluent
import FluentSQLiteDriver

struct CreateHash: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        return database.schema("hashes")
            .id()
            .field("value", .string, .required)
            .field("created_at", .datetime, .required)
            .create()
    }

    func revert(on database: Database) -> EventLoopFuture<Void> {
        return database.schema("hashes").delete()
    }
}