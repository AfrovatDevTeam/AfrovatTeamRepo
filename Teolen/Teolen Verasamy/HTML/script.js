function greet() {
    alert("Hello from external file!");
}----Objects
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>JS Objects in Web Design</title>
    <style>
        body { font-family: sans-serif; padding: 20px; line-height: 1.6; background-color: #f4f4f4; }
        .card { background: white; padding: 20px; border-radius: 8px; box-shadow: 0 2px 5px rgba(0,0,0,0.1); margin-bottom: 20px; max-width: 300px; }
        h2 { color: #d35400; margin-top: 0; }
        .price { font-weight: bold; color: green; }
    </style>
</head>
<body>

    <h1>Web Design Object Examples</h1>

    <div class="card" id="user-card">
        <h2>User Profile</h2>
        <p id="user-info"></p>
    </div>

    <div class="card" id="product-card">
        <h2>Product Info</h2>
        <p id="product-name"></p>
        <p class="price" id="product-price"></p>
    </div>

    <script>
        // 1. Defining the Objects
        const user = {
            username: "DesignPro24",
            membership: "Gold",
            loginCount: 52
        };

        const product = {
            name: "Wireless Headphones",
            price: 100.99,
            color: "Matte Black"
        };

        // 2. Displaying Object data in HTML
        // We use "dot notation" (object.property) to grab the values
        
        document.getElementById("user-info").innerHTML = 
            `User: ${user.username} <br> Level: ${user.membership}`;

        document.getElementById("product-name").innerText = product.name;
        document.getElementById("product-price").innerText = `$${product.price}`;
    </script>

</body>
</html>