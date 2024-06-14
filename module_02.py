import psycopg2
from psycopg2 import sql

import psycopg2
from psycopg2 import sql


def get_client_orders_with_payment():
    conn = None
    try:
        conn = psycopg2.connect(
            dbname="demo",
            user="postgres",
            password="123",
            host="localhost",
            port="5432"
        )
        cur = conn.cursor()
        query = """
            SELECT o.client_surname, o.id, o.order_date,
                   (e.hourly_rate * o.work_hours) AS payment_due
            FROM orders o
            JOIN employees e ON o.master = e.id
        """
        cur.execute(query)
        rows = cur.fetchall()
        for row in rows:
            print(row)
        cur.close()
    except Exception as e:
        print(f"Failed to retrieve data: {e}")
    finally:
        if conn is not None:
            conn.close()




def delete_unused_services():
    conn = None
    try:
        conn = psycopg2.connect(
            dbname="demo",
            user="postgres",
            password="123",
            host="localhost",
            port="5432"
        )
        cur = conn.cursor()
        query = """
            DELETE FROM services
            WHERE id NOT IN (
                SELECT DISTINCT service_type FROM orders
            )
        """
        cur.execute(query)
        conn.commit()
        print(f"{cur.rowcount} unused services deleted.")
        cur.close()
    except Exception as e:
        print(f"Failed to delete unused services: {e}")
    finally:
        if conn is not None:
            conn.close()




def update_popular_master_hourly_rate():
    conn = None
    try:
        conn = psycopg2.connect(
            dbname="demo",
            user="postgres",
            password="123",
            host="localhost",
            port="5432"
        )
        cur = conn.cursor()
        query = """
            WITH popular_master AS (
                SELECT master
                FROM orders
                GROUP BY master
                ORDER BY COUNT(*) DESC
                LIMIT 1
            )
            UPDATE employees
            SET hourly_rate = hourly_rate * 1.10
            WHERE id IN (SELECT master FROM popular_master)
        """
        cur.execute(query)
        conn.commit()
        print(f"Hourly rate updated for popular master. Rows affected: {cur.rowcount}")
        cur.close()
    except Exception as e:
        print(f"Failed to update hourly rate: {e}")
    finally:
        if conn is not None:
            conn.close()



print("1. Вывести информацию о заказе;\n"
      "2. Удалить непопулярные услуги;\n"
      "3. Повысить ставку популярному мастеру на 10%.")
choice = input("Сделайте выбор (1, 2 или 3): ")

if choice == "1":
    get_client_orders_with_payment()
elif choice == "2":
    delete_unused_services()
elif choice == "3":
    update_popular_master_hourly_rate()
else:
    print("В списке нет вашего варианта.")