import psycopg2
import tkinter as tk
from tkinter import ttk
from tkinter import messagebox

def get_client_names():
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
        query = "SELECT DISTINCT client_surname FROM orders"
        cur.execute(query)
        client_names = [row[0] for row in cur.fetchall()]
        cur.close()
        return client_names
    except Exception as e:
        messagebox.showerror("Error", f"Failed to retrieve client names: {e}")
        return []
    finally:
        if conn is not None:
            conn.close()

def filter_entries():
    client_name = client_var.get()
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
            SELECT client_surname, client_phone_num, email, auto_mark, master
            FROM orders
            WHERE client_surname = %s
        """
        cur.execute(query, (client_name,))
        rows = cur.fetchall()
        update_table(rows)
        cur.close()
    except Exception as e:
        messagebox.showerror("Error", f"Failed to retrieve data: {e}")
    finally:
        if conn is not None:
            conn.close()

def show_all_entries():
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
            SELECT client_surname, client_phone_num, email, auto_mark, master
            FROM orders
        """
        cur.execute(query)
        rows = cur.fetchall()
        update_table(rows)
        cur.close()
    except Exception as e:
        messagebox.showerror("Error", f"Failed to retrieve data: {e}")
    finally:
        if conn is not None:
            conn.close()

def search_entries():
    search_string = entry_search.get()
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
            SELECT client_surname, client_phone_num, email, auto_mark, master
            FROM orders
            WHERE client_surname ILIKE %s
            OR client_phone_num ILIKE %s
            OR email ILIKE %s
            OR auto_mark ILIKE %s
            OR master::text ILIKE %s
        """
        search_pattern = f"%{search_string}%"
        cur.execute(query, (search_pattern, search_pattern, search_pattern, search_pattern, search_pattern))
        rows = cur.fetchall()
        update_table(rows)
        cur.close()
    except Exception as e:
        messagebox.showerror("Error", f"Failed to retrieve data: {e}")
    finally:
        if conn is not None:
            conn.close()

def sort_entries():
    sort_field = sort_var.get()
    sort_order = "ASC" if sort_order_var.get() == "По возрастанию" else "DESC"
    sort_column = {
        "Клиент": "client_surname",
        "Марка авто": "auto_mark",
        "Мастер": "master"
    }.get(sort_field, "client_surname")

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
        query = f"""
            SELECT client_surname, client_phone_num, email, auto_mark, master
            FROM orders
            ORDER BY {sort_column} {sort_order}
        """
        cur.execute(query)
        rows = cur.fetchall()
        update_table(rows)
        cur.close()
    except Exception as e:
        messagebox.showerror("Error", f"Failed to retrieve data: {e}")
    finally:
        if conn is not None:
            conn.close()

def update_table(rows):
    for item in tree.get_children():
        tree.delete(item)
    for row in rows:
        tree.insert("", tk.END, values=row)

# Main application window
root = tk.Tk()
root.title("Работа с заказами клиентов")
root.minsize(600, 300)
root.maxsize(1920, 1080)

# Configure the grid layout for the main window
root.columnconfigure(0, weight=1)
root.rowconfigure(0, weight=0)
root.rowconfigure(1, weight=0)
root.rowconfigure(2, weight=1)

# Frame for the top controls
frame_controls = tk.Frame(root)
frame_controls.grid(row=0, column=0, padx=10, pady=10, sticky="ew")

frame_controls.columnconfigure(1, weight=1)

# Dropdown for selecting a client
label_select_client = tk.Label(frame_controls, text="Выберите клиента")
label_select_client.grid(row=0, column=0, padx=5, pady=5, sticky="w")
client_var = tk.StringVar()
dropdown_client = ttk.Combobox(frame_controls, textvariable=client_var)
dropdown_client['values'] = get_client_names()
dropdown_client.grid(row=0, column=1, padx=5, pady=5, sticky="ew")

# Filter and Show All buttons
button_filter = tk.Button(frame_controls, text="Фильтровать", command=filter_entries)
button_filter.grid(row=0, column=2, padx=5, pady=5, sticky="ew")
button_show_all = tk.Button(frame_controls, text="Показать все", command=show_all_entries)
button_show_all.grid(row=0, column=3, padx=5, pady=5, sticky="ew")

# Entry for search string
label_search = tk.Label(frame_controls, text="Введите строку поиска")
label_search.grid(row=1, column=0, padx=5, pady=5, sticky="w")
entry_search = tk.Entry(frame_controls)
entry_search.grid(row=1, column=1, padx=5, pady=5, sticky="ew")
button_search = tk.Button(frame_controls, text="Найти", command=search_entries)
button_search.grid(row=1, column=2, padx=5, pady=5, sticky="ew")

# Frame for sorting options
frame_sort = tk.Frame(root)
frame_sort.grid(row=1, column=0, padx=10, pady=10, sticky="ew")

frame_sort.columnconfigure(1, weight=1)
frame_sort.columnconfigure(3, weight=1)

label_sort = tk.Label(frame_sort, text="Выберите поле для сортировки")
label_sort.grid(row=0, column=0, padx=5, pady=5, sticky="w")
sort_var = tk.StringVar(value="Клиент")
sort_options = ttk.Combobox(frame_sort, textvariable=sort_var)
sort_options['values'] = ["Клиент", "Марка авто", "Мастер"]
sort_options.grid(row=0, column=1, padx=5, pady=5, sticky="ew")

# Sorting order
sort_order_var = tk.StringVar(value="По возрастанию")
radio_asc = tk.Radiobutton(frame_sort, text="По возрастанию", variable=sort_order_var, value="По возрастанию", command=sort_entries)
radio_desc = tk.Radiobutton(frame_sort, text="По убыванию", variable=sort_order_var, value="По убыванию", command=sort_entries)
radio_asc.grid(row=0, column=2, padx=5, pady=5, sticky="w")
radio_desc.grid(row=0, column=3, padx=5, pady=5, sticky="w")

# Frame for the table
frame_table = tk.Frame(root)
frame_table.grid(row=2, column=0, padx=10, pady=10, sticky="nsew")

frame_table.columnconfigure(0, weight=1)
frame_table.rowconfigure(0, weight=1)

# Table with columns: Клиент, Телефон, Электронная почта, Марка авто, Мастер
columns = ("Клиент", "Телефон", "Электронная почта", "Марка авто", "Мастер")
tree = ttk.Treeview(frame_table, columns=columns, show='headings')

# Define headings
for col in columns:
    tree.heading(col, text=col)

tree.grid(row=0, column=0, sticky="nsew")

# Add vertical scrollbar
scrollbar_y = ttk.Scrollbar(frame_table, orient=tk.VERTICAL, command=tree.yview)
tree.configure(yscroll=scrollbar_y.set)
scrollbar_y.grid(row=0, column=1, sticky="ns")

# Add horizontal scrollbar
scrollbar_x = ttk.Scrollbar(frame_table, orient=tk.HORIZONTAL, command=tree.xview)
tree.configure(xscroll=scrollbar_x.set)
scrollbar_x.grid(row=1, column=0, sticky="ew")

# Initial data load
show_all_entries()

# Run the application
root.mainloop()