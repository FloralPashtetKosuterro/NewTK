import asyncio
from tkinter import *
from tkinter import ttk
import secrets, string, psycopg2
from asyncio import *
import random
import hashlib

# db connect
connection = psycopg2.connect(user="postgres", password="123", host="localhost",
                              port="5432",
                              database="demo")

# cursor
cursor = connection.cursor()
connection.autocommit = True


def delete_bd_and_users():
    cursor.execute("SELECT datname FROM pg_database")
    databases = cursor.fetchall()
    for database in databases:
        if database[0] not in ['postgres', 'demo', 'template0', 'template1']:
            try:
                cursor.execute(f"drop database \"{database[0]}\" WITH (FORCE)")
            except:
                print(f"Закройте бд: \"{database[0]}\"")
            else:
                print(f"\"{database[0]}\" - успешно удален")

    cursor.execute("SELECT usename FROM pg_user")
    users = cursor.fetchall()
    for user in users:
        if user[0] not in ['postgres', 'sa']:
            try:
                cursor.execute(f"DROP USER \"{user[0]}\"")
            except:
                print("Что-то пошло не так")
            else:
                print(f"{user[0]} - успешно удален")


def create_databases():
    for i in range(14):
        cursor.execute(f'CREATE DATABASE \"Bs{i + 1}\"')


def generate_random_password(length):
    letters = string.ascii_letters
    digits = string.digits
    characters = letters + digits
    random_string = ''.join(secrets.choice(characters) for _ in range(length))
    if not any(char.isdigit() for char in random_string):
        random_string = random_string[:-1] + secrets.choice(digits)
    return random_string


def create_users():
    for i in range(14):
        cursor.execute(f"CREATE USER user{i + 1} WITH PASSWORD '{generate_random_password(5)}' "
                       f"NOSUPERUSER NOCREATEDB NOCREATEROLE")
        cursor.execute(f"GRANT ALL PRIVILEGES ON DATABASE \"Bs{i + 1}\""
                       f" TO user{i + 1}")


print("1. Удалить всех пользователей и базы данных;\n"
      "2. Создать 14 баз данных;\n"
      "3. Создать 14 пользователей.")
choice = input("Сделайте выбор (1, 2 или 3): ")

if choice == "1":
    delete_bd_and_users()
elif choice == "2":
    create_databases()
elif choice == "3":
    create_users()
else:
    print("В списке нет вашего варианта.")
