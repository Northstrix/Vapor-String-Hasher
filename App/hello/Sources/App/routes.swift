import Vapor
import WhirlpoolSwift

// Import the WhirlpoolSwift package

// Define the input data structure for hash calculation
struct HashResponse: Content {
    let hash: String
    let success: Bool
}

struct InputData: Content {
    let input: String
    let algorithm: String // Add this line to include the algorithm property
}

// Define the routes
func routes(_ app: Application) throws {
    // Home route
    app.get {
        req async in
        "Welcome to the Whirlpool Hash Application!"
    }

    // Route to get all hashes
app.get("hashes") { req async throws -> Response in
    let hashes = try await Hash.query(on: req.db).all()
    
    var html = """
    <!DOCTYPE html>
    <html>
    <head>
        <title>Hashes</title>
        <style>
            * {
                box-sizing: border-box;
            }
            
            html, body {
                padding: 40px;
                font-size: 62.5%;
            }
            
            body {
                padding: 20px;
                background-color: #5BB9B8;
                line-height: 1.6;
                -webkit-font-smoothing: antialiased;
                color: #fff;
                font-size: 1.6rem;
                font-family: 'Lato', sans-serif;
            }
            
            p {
                text-align: center;
                margin: 20px 0 60px;
            }
            
            main {
                background-color: #2C3845;
            }
            
            h1 {
                text-align: center;
                font-weight: 300;
            }
            
            table {
                display: block;
            }
            
            tr, td, tbody, tfoot {
                display: block;
            }
            
            thead {
                display: none;
            }
            
            tr {
                padding-bottom: 10px;
            }
            
            td {
                padding: 10px 10px 0;
                text-align: center;
            }
            
            td:before {
                content: attr(data-title);
                color: #6b7c8c;
                text-transform: uppercase;
                font-size: 1.4rem;
                padding-right: 10px;
                display: block;
            }
            
            table {
                width: 100%;
            }
            
            th {
                text-align: left;
                font-weight: 700;
            }
            
            thead th {
                background-color: #252e39;
                color: #fff;
                border: 1px solid #252e39;
            }
            
            tfoot th {
                display: block;
                padding: 10px;
                text-align: center;
                color: #a0b3b8;
            }
            
            .button {
                line-height: 1;
                display: inline-block;
                font-size: 1.2rem;
                text-decoration: none;
                border-radius: 5px;
                color: #fff;
                padding: 8px;
                background-color: #4e9494;
            }
            
            .select {
                padding-bottom: 20px;
                border-bottom: 1px solid #293241;
            }
            
            .detail {
                background-color: #BD2A4E;
                width: 100%;
                height: 100%;
                padding: 40px 0;
                position: fixed;
                top: 0;
                left: 0;
                overflow: auto;
                transform: translateX(-100%);
                transition: transform 0.3s ease-out;
            }
            
            .detail.open {
                transform: translateX(0);
            }
            
            .detail-container {
                margin: 0 auto;
                padding: 40px;
                max-width: 500px;
            }
            
            dl {
                margin: 0;
                padding: 0;
            }
            
            dt {
                font-size: 2.2rem;
                font-weight: 300;
            }
            
            dd {
                margin: 0 0 40px 0;
                font-size: 1.8rem;
                padding-bottom: 5px;
                border-bottom: 1px solid #a83c5c;
                box-shadow: 0 1px 0 #c44370;
            }
            
            .close {
                background: none;
                padding: 18px;
                color: #fff;
                font-weight: 300;
                border: 1px solid rgba(255, 255, 255, 0.4);
                border-radius: 4px;
                line-height: 1;
                font-size: 1.8rem;
                position: fixed;
                right: 40px;
                top: 20px;
                transition: border 0.3s linear;
            }
            
            .close:hover, .close:focus {
                background-color: #a83c5c;
                border: 1px solid #a83c5c;
            }
            
            @media (min-width: 460px) {
                td {
                    text-align: left;
                }
                
                td:before {
                    display: inline-block;
                    text-align: right;
                    width: 140px;
                }
                
                .select {
                    padding-left: 160px;
                }
            }
            
            @media (min-width: 720px) {
                table {
                    display: table;
                }
                
                tr {
                    display: table-row;
                }
                
                td, th {
                    display: table-cell;
                }
                
                tbody {
                    display: table-row-group;
                }
                
                thead {
                    display: table-header-group;
                }
                
                tfoot {
                    display: table-footer-group;
                }
                
                td {
                    border: 1px solid #293241;
                }
                
                td:before {
                    display: none;
                }
                
                td, th {
                    padding: 10px;
                }
                
                tr:nth-child(2n+2) td {
                    background-color: #1e2833;
                }
                
                tfoot th {
                    display: table-cell;
                }
                
                .select {
                    padding: 10px;
                }
            }
        </style>
    </head>
    <body>
        <main>
            <h1>Hashes</h1>
            <table>
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Value</th>
                        <th>Created At</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
    """
    
         for hash in hashes {
            html += """
            <tr id="hash-\(hash.id?.uuidString ?? "")">
                <td data-title="ID">\(hash.id?.uuidString ?? "N/A")</td>
                <td data-title="Value">\(hash.value)</td>
                <td data-title="Created At">\(hash.createdAt?.description ?? "N/A")</td>
                <td data-title="Actions">
                    <button class="button delete-button" data-hash-id="\(hash.id?.uuidString ?? "")">Delete</button>
                </td>
            </tr>
            """
        }
        html += """
                </tbody>
            </table>
        </main>

        <div class="detail">
            <div class="detail-container">
                <dl>
                    <dt>Hash Details</dt>
                    <dd>
                        <p>ID: \(hashes.first?.id?.uuidString ?? "N/A")</p>
                        <p>Value: \(hashes.first?.value ?? "")</p>
                        <p>Created At: \(hashes.first?.createdAt?.description ?? "N/A")</p>
                    </dd>
                </dl>
                <a href="#" class="close">Close</a>
            </div>
        </div>

        <script>
            document.querySelectorAll('.delete-button').forEach(button => {
                button.addEventListener('click', function() {
                    const hashID = this.getAttribute('data-hash-id');
                    fetch(`/delete/${hashID}`, {
                        method: 'DELETE'
                    })
                    .then(response => {
                        if (response.ok) {
                            // Remove the deleted row from the table
                            const row = document.getElementById(`hash-${hashID}`);
                            if (row) {
                                row.remove();
                            }
                        } else {
                            alert('Failed to delete the record.');
                        }
                    })
                    .catch(error => {
                        console.error('Error:', error);
                        alert('An error occurred while deleting the record.');
                    });
                });
            });
        </script>
    </body>
    </html>
    """
    
    return Response(status: .ok, body: .init(string: html))
}

    // Route to get a specific hash by ID
    app.get("hashes", ":hashID") {
        req async throws -> Hash in
        guard let hashID = req.parameters.get("hashID", as: UUID.self) else {
            throw Abort(.badRequest)
        }

        // Unwrap the optional Hash
        if let hash = try await Hash.find(hashID, on: req.db) {
            return hash
        } else {
            throw Abort(.notFound)
        }
    }

    // Route to delete a specific hash by ID using DELETE
    app.delete("delete", ":hashID") { req async throws -> HTTPStatus in
        guard let hashID = req.parameters.get("hashID", as: UUID.self) else {
            throw Abort(.badRequest)
        }

        // Unwrap the optional Hash
        guard let hash = try await Hash.find(hashID, on: req.db) else {
            throw Abort(.notFound)
        }

        // Delete the hash
        try await hash.delete(on: req.db)
        return .noContent
    }

    // Route to display the input form
app.get("hash") { req async -> Response in
    let html = """
    <!DOCTYPE html>
    <html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <link href="https://fonts.googleapis.com/css?family=Montserrat:400,800" rel="stylesheet">
        <style>
            @import url('https://fonts.googleapis.com/css?family=Montserrat:400,800');
            
            * {
                box-sizing: border-box;
            }
            
            body {
                background-color: #dde5f4; /* Set the webpage background */
                display: flex;
                justify-content: center;
                align-items: center;
                flex-direction: column;
                font-family: 'Montserrat', sans-serif;
                height: 100vh;
                margin: -20px 0 50px;
            }
            
            .container {
                background-color: #242424; /* Set the form background */
                border-radius: 10px;
                box-shadow: 0 14px 28px rgba(0,0,0,0.25), 0 10px 10px rgba(0,0,0,0.22);
                position: relative;
                overflow: hidden;
                width: 768px;
                max-width: 100%;
                min-height: 480px;
            }
            
            .form-container {
                position: absolute;
                top: 0;
                height: 100%;
                transition: all 0.6s ease-in-out;
            }
            
            .sign-in-container {
                left: 0;
                width: 50%;
                z-index: 2;
            }
            
            .container.right-panel-active .sign-in-container {
                transform: translateX(100%);
            }
            
            .sign-up-container {
                left: 0;
                width: 50%;
                opacity: 0;
                z-index: 1;
            }
            
            .container.right-panel-active .sign-up-container {
                transform: translateX(100%);
                opacity: 1;
                z-index: 5;
                animation: show 0.6s;
            }
            
            @keyframes show {
                0%, 49.99% {
                    opacity: 0;
                    z-index: 1;
                }
                50%, 100% {
                    opacity: 1;
                    z-index: 5;
                }
            }
            
            .overlay-container {
                position: absolute;
                top: 0;
                left: 50%;
                width: 50%;
                height: 100%;
                overflow: hidden;
                transition: transform 0.6s ease-in-out;
                z-index: 100;
            }
            
            .container.right-panel-active .overlay-container {
                transform: translateX(-100%);
            }
            
            .overlay {
                background: -webkit-linear-gradient(to right, #3D4785, #0083EB);
                background: linear-gradient(to right, #3D4785, #0083EB);
                background-repeat: no-repeat;
                background-size: cover;
                background-position: 0 0;
                color: #FFFFFF;
                position: relative;
                left: -100%;
                height: 100%;
                width: 200%;
                transform: translateX(0);
                transition: transform 0.6s ease-in-out;
            }
            
            .container.right-panel-active .overlay {
                transform: translateX(50%);
            }
            
            .overlay-panel {
                position: absolute;
                display: flex;
                align-items: center;
                justify-content: center;
                flex-direction: column;
                padding: 0 40px;
                text-align: center;
                top: 0;
                height: 100%;
                width: 50%;
                transform: translateX(0);
                transition: transform 0.6s ease-in-out;
            }
            
            .overlay-left {
                transform: translateX(-20%);
            }
            
            .container.right-panel-active .overlay-left {
                transform: translateX(0);
            }
            
            .overlay-right {
                right: 0;
                transform: translateX(0);
            }
            
            .container.right-panel-active .overlay-right {
                transform: translateX(20%);
            }
            
            .social-container {
                margin: 20px 0;
            }
            
            .social-container a {
                border: 1px solid #DDDDDD;
                border-radius: 50%;
                display: inline-flex;
                justify-content: center;
                align-items: center;
                margin: 0 5px;
                height: 40px;
                width: 40px;
            }
            
            button {
                border-radius: 20px;
                border: 1px solid #0083EB;
                background-color: #0083EB;
                color: #FFFFFF;
                font-size: 12px;
                font-weight: bold;
                padding: 12px 45px;
                letter-spacing: 1px;
                text-transform: none; /* No capitalization */
                transition: transform 80ms ease-in;
                margin: 20px 0;
            }
            
            button:active {
                transform: scale(0.95);
            }
            
            button:focus {
                outline: none;
            }
            
            button.ghost {
                background-color: transparent;
                border: 2px solid #FFFFFF;
                color: #FFFFFF;
                font-size: 12px;
                font-weight: bold;
                padding: 12px 24px;
                margin: 5px;
                letter-spacing: 1px;
                text-transform: none; /* No capitalization */
                border-radius: 20px;
                transition: all 0.8s ease;
                position: relative;
                overflow: hidden;
            }
            
            button.ghost:hover,
            button:hover {
                border: 2px solid #FFFFFF;
                background: #FFFFFF;
                color: #242424;
                box-shadow: 0 0 5px #FFFFFF,
                            0 0 25px #FFFFFF,
                            0 0 50px #FFFFFF,
                            0 0 200px #FFFFFF;
                transition: all 0.8s ease;
            }
            
            form {
                background-color: #242424; /* Set the form background */
                color: #eeeeee; /* Set the text color */
                display: flex;
                align-items: center;
                justify-content: center;
                flex-direction: column;
                padding: 0 50px;
                height: 100%;
                text-align: center;
            }
            
            input {
                background-color: #eee;
                border: none;
                padding: 12px 15px;
                margin: 8px 0;
                width: 100%;
            }
            
            #notification-container {
                display: flex;
                flex-direction: column;
                align-items: flex-end;
                position: fixed;
                bottom: 10px;
                right: 10px;
                z-index: 1001;
            }
            
            .notification-toast {
                background-color: #F1F7FE;
                color: #4E54C8;
                border-radius: 5px;
                padding: 1rem 2rem;
                margin: 0.5rem;
                font-family: "Poppins", sans-serif;
                opacity: 1;
                transition: opacity 0.5s ease-out;
            }
            
            .notification-toast.error {
                color: #FF0000;
            }
            
            .notification-toast.fade-out {
                opacity: 0;
            }
        </style>
        <title>Hash Calculation</title>
    </head>
    <body>
        <div class="container" id="container">
            <div class="form-container sign-up-container">
                <form action="#">
                    <h1>Whirlpool Hash</h1>
                    <input type="text" placeholder="Enter your string" id="whirlpool-input" />
                    <button onclick="calculateWhirlpoolHash(event)">Calculate</button>
                    <div id="whirlpool-result"></div>
                </form>
            </div>
            <div class="form-container sign-in-container">
                <form action="#">
                    <h1>SHA-512 Hash</h1>
                    <input type="text" placeholder="Enter your string" id="sha512-input" />
                    <button onclick="calculateSHA512Hash(event)">Calculate</button>
                    <div id="sha512-result"></div>
                </form>
            </div>
            <div class="overlay-container">
                <div class="overlay">
                    <div class="overlay-panel overlay-left">
                        <h1>Hopefully you enjoyed using this tool to hash your strings with Whirlpool!</h1>
                        <p>You can also use this tool to hash your data using another hash function.</p>
                        <button class="ghost" id="signIn">Hash with SHA-512</button>
                    </div>
                    <div class="overlay-panel overlay-right">
                        <h1>Hopefully you enjoyed using this tool to hash your strings with SHA-512!</h1>
                        <p>You can also use this tool to hash your data using another hash function.</p>
                        <button class="ghost" id="signUp">Hash with Whirlpool</button>
                    </div>
                </div>
            </div>
        </div>
        
        <div id="notification-container"></div>
        
        <script>
            function calculateWhirlpoolHash(event) {
                event.preventDefault();
                const input = document.getElementById('whirlpool-input').value;
                fetch('/hash', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json'
                    },
                    body: JSON.stringify({ input: input, algorithm: "whirlpool" }) // Pass the algorithm name
                })
                .then(response => {
                    if (!response.ok) {
                        throw new Error('Network response was not ok');
                    }
                    return response.json();
                })
                .then(data => {
                    if (data && data.success) {
                        showNotification('Whirlpool Hash: ' + data.hash);
                        showNotification('Hash added to database successfully!');
                    } else {
                        throw new Error('Failed to add hash to the database');
                    }
                })
                .catch(error => {
                    showNotification('Error: ' + error.message, true);
                });
            }

            function calculateSHA512Hash(event) {
                event.preventDefault();
                const input = document.getElementById('sha512-input').value;
                fetch('/hash', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json'
                    },
                    body: JSON.stringify({ input: input, algorithm: "sha512" }) // Pass the algorithm name
                })
                .then(response => {
                    if (!response.ok) {
                        throw new Error('Network response was not ok');
                    }
                    return response.json();
                })
                .then(data => {
                    if (data && data.success) {
                        showNotification('SHA-512 Hash: ' + data.hash);
                        showNotification('Hash added to database successfully!');
                    } else {
                        throw new Error('Failed to add hash to the database');
                    }
                })
                .catch(error => {
                    showNotification('Error: ' + error.message, true);
                });
            }
            
            function showNotification(message, isError = false) {
                const container = document.getElementById('notification-container');
                const notification = document.createElement('div');
                notification.classList.add('notification-toast');
                if (isError) {
                    notification.classList.add('error');
                }
                notification.textContent = message;
                container.appendChild(notification);

                setTimeout(() => {
                    notification.classList.add('fade-out');
                    setTimeout(() => {
                        notification.remove();
                    }, 500);
                }, 4500);
            }
            
            const signUpButton = document.getElementById('signUp');
            const signInButton = document.getElementById('signIn');
            const container = document.getElementById('container');
            
            signUpButton.addEventListener('click', () => {
                container.classList.add("right-panel-active");
            });
            
            signInButton.addEventListener('click', () => {
                container.classList.remove("right-panel-active");
            });
        </script>
    </body>
    </html>
    """
    
    return Response(status: .ok, body: .init(string: html))
}

// Function to calculate SHA-512 hash
func hashWithSHA512(_ input: String) throws -> String {
    // Convert input string to Data
    guard let inputData = input.data(using: .utf8) else {
        throw Abort(.badRequest, reason: "Invalid input data.")
    }

    // Use the SHA512 class to compute the hash
    let digest = SHA512.hash(data: inputData)
    // This returns a 64-byte digest

    // Convert the digest to a hexadecimal string
    return digest.map { String(format: "%02hhx", $0) }.joined()
}

// Function to hash a string using Whirlpool
func hashWithWhirlpool(_ input: String) throws -> String {
    // Convert input string to Data
    guard let inputData = input.data(using: .utf8) else {
        throw Abort(.badRequest, reason: "Invalid input data.")
    }

    // Use the Whirlpool class to compute the hash
    let digest = Whirlpool.hash(data: inputData)
    // This returns a 64-byte digest

    // Convert the digest to a hexadecimal string
    return digest.map { String(format: "%02hhx", $0) }.joined()
}

// Updated function to handle both hash calculations and database insertions
    app.post("hash") { req async throws -> HashResponse in
        let input = try req.content.decode(InputData.self)
        let inputString = input.input
        let algorithm = input.algorithm.lowercased() // Get the algorithm name

        // Determine which hash function to use based on the algorithm name
        let hash: String
        switch algorithm {
        case "sha512":
            hash = try hashWithSHA512(inputString)
        case "whirlpool":
            hash = try hashWithWhirlpool(inputString)
        default:
            throw Abort(.badRequest, reason: "Unsupported hash algorithm.")
        }

        // Save the hash to the database
        let newHash = Hash(value: hash)
        try await newHash.save(on: req.db)

        // Return a structured JSON response indicating success
        return HashResponse(hash: hash, success: true)
    }
}

// Register the routes
public func configure(_ app: Application) throws {
    // Configure the database, middleware, etc.
    // Call the routes function
    try routes(app)
}