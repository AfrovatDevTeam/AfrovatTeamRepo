@app.route("/payments", methods=["POST"])
@limiter.limit("5 per minute")
def create_payment():


    if "user_id" not in session:
        return jsonify({"message": "Unauthorized"}), 401


    user_id = session["user_id"]
    amount = request.form.get("amount")


    if not amount:
        return jsonify({"message": "Missing amount"}), 400


    try:
        amount = float(amount)
        if amount <= 0:
            return jsonify({"message": "Invalid amount"}), 400
    except:
        return jsonify({"message": "Invalid format"}), 400


    try:
        with get_db_connection() as conn:
            cursor = conn.cursor()


            cursor.execute("""
                INSERT INTO payments (user_id, amount, status, created_at)
                VALUES (?, ?, ?, GETDATE())
            """, (user_id, amount, "pending"))


            conn.commit()


            return jsonify({"message": "Payment created"}), 201


    except Exception as e:
        logging.error(e)
        return jsonify({"message": "Server error"}), 500




View payment:
@app.route("/payments/<int:user_id>", methods=["GET"])
def payment_history(user_id):


    if "user_id" not in session:
        return jsonify({"message": "Unauthorized"}), 401


    if session["user_id"] != user_id and session.get("role") != "staff":
        return jsonify({"message": "Access denied"}), 403


    try:
        with get_db_connection() as conn:
            cursor = conn.cursor()


            cursor.execute("""
                SELECT payment_id, user_id, amount, status, created_at
                FROM payments
                WHERE user_id = ?
                ORDER BY created_at DESC
            """, (user_id,))


            rows = cursor.fetchall()
            columns = [col[0] for col in cursor.description]


            return jsonify([dict(zip(columns, r)) for r in rows]), 200


    except Exception as e:
        logging.error(e)
        return jsonify({"message": "Server error"}), 500

Delete payment:
@app.route("/payments/<int:payment_id>", methods=["DELETE"])
@role_required("staff")
def delete_payment(payment_id):


    try:
        with get_db_connection() as conn:
            cursor = conn.cursor()


            cursor.execute("""
                DELETE FROM payments
                WHERE payment_id = ?
            """, (payment_id,))


            conn.commit()


            return jsonify({"message": "Payment deleted"}), 200


    except Exception as e:
        logging.error(f"Delete payment error: {e}")
        return jsonify({"message": "Internal server error"}), 500


