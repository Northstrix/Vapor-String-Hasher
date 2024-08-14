import Vapor
import Fluent
import FluentSQLiteDriver

// Configures your application
public func configure(_ app: Application) async throws {
    // Configure the SQLite database
    app.databases.use(.sqlite(.file("db.sqlite")), as: .sqlite)

    // Add migrations
    app.migrations.add(CreateHash())

    // Run migrations without using wait()
    try await app.autoMigrate()

    // Uncomment to serve files from /Public folder
    // app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))

    // Register routes
    try routes(app)
}