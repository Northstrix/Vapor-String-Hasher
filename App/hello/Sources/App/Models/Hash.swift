import Fluent
import Vapor

final class Hash: Model, Content {
    static let schema = "hashes"

    @ID(key: .id)
    var id: UUID?

    @Field(key: "value")
    var value: String

    @Timestamp(key: "created_at", on: .create)
    var createdAt: Date?

    init() { }

    init(id: UUID? = nil, value: String) {
        self.id = id
        self.value = value
    }
}