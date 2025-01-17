PGDMP      6    	            |            demo    16.1    16.0 ,    �           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false            �           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false            �           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false            �           1262    18957    demo    DATABASE     x   CREATE DATABASE demo WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'Russian_Russia.1251';
    DROP DATABASE demo;
                postgres    false                        2615    2200    public    SCHEMA     2   -- *not* creating schema, since initdb creates it
 2   -- *not* dropping schema, since initdb creates it
                postgres    false            �           0    0    SCHEMA public    ACL     Q   REVOKE USAGE ON SCHEMA public FROM PUBLIC;
GRANT ALL ON SCHEMA public TO PUBLIC;
                   postgres    false    6                        3079    18958 	   adminpack 	   EXTENSION     A   CREATE EXTENSION IF NOT EXISTS adminpack WITH SCHEMA pg_catalog;
    DROP EXTENSION adminpack;
                   false            �           0    0    EXTENSION adminpack    COMMENT     M   COMMENT ON EXTENSION adminpack IS 'administrative functions for PostgreSQL';
                        false    2            �            1255    18968    check_email_validity() 	   PROCEDURE     �  CREATE PROCEDURE public.check_email_validity()
    LANGUAGE plpgsql
    AS $_$
DECLARE
  email_record RECORD;
  email TEXT;
  is_valid INTEGER;
BEGIN
  FOR email_record IN SELECT orders.email FROM orders LOOP
	email := email_record.email;
    IF (email ~ '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,}$') AND
        email NOT SIMILAR TO '%["<>\"]%' THEN
      is_valid := 1;
    ELSE
      is_valid := 0;
    END IF;
    INSERT INTO email_validity_results(email, is_valid)
    VALUES (email, is_valid);
    IF is_valid = 1 THEN
      RAISE NOTICE 'Email % is valid', email;
    ELSE
      RAISE NOTICE 'Email % is invalid', email;
    END IF;
  END LOOP;
END;
$_$;
 .   DROP PROCEDURE public.check_email_validity();
       public          postgres    false    6            �            1255    19265    log_price_change()    FUNCTION     �   CREATE FUNCTION public.log_price_change() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    INSERT INTO "HistoryCost" (change_date, old_cost, new_cost)
    VALUES (CURRENT_TIMESTAMP, OLD.current_cost, NEW.current_cost);
    RETURN NEW;
END;
$$;
 )   DROP FUNCTION public.log_price_change();
       public          postgres    false    6            �            1259    19232    HistoryCost    TABLE     �   CREATE TABLE public."HistoryCost" (
    change_date date,
    service_id integer,
    old_cost numeric(9,2),
    new_cost numeric(9,2),
    id integer NOT NULL,
    test text
);
 !   DROP TABLE public."HistoryCost";
       public         heap    postgres    false    6            �            1259    19254    HistoryCost_id_seq    SEQUENCE     �   CREATE SEQUENCE public."HistoryCost_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 +   DROP SEQUENCE public."HistoryCost_id_seq";
       public          postgres    false    6    221            �           0    0    HistoryCost_id_seq    SEQUENCE OWNED BY     M   ALTER SEQUENCE public."HistoryCost_id_seq" OWNED BY public."HistoryCost".id;
          public          postgres    false    224            �            1259    18975    email_validity_results    TABLE     m   CREATE TABLE public.email_validity_results (
    id bigint NOT NULL,
    email text,
    is_valid integer
);
 *   DROP TABLE public.email_validity_results;
       public         heap    postgres    false    6            �            1259    18980    email_validity_results_id_seq    SEQUENCE     �   CREATE SEQUENCE public.email_validity_results_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 4   DROP SEQUENCE public.email_validity_results_id_seq;
       public          postgres    false    6    216            �           0    0    email_validity_results_id_seq    SEQUENCE OWNED BY     _   ALTER SEQUENCE public.email_validity_results_id_seq OWNED BY public.email_validity_results.id;
          public          postgres    false    217            �            1259    19199 	   employees    TABLE     S  CREATE TABLE public.employees (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    surname character varying(50) NOT NULL,
    name character varying(50) NOT NULL,
    patronymic character varying(50),
    "position" character varying(50) NOT NULL,
    birth_date date NOT NULL,
    phone character varying(20),
    address_city character varying(50),
    address_street character varying(50),
    address_house character varying(10),
    address_apartment character varying(10),
    hourly_rate numeric(10,2),
    CONSTRAINT employees_hourly_rate_check CHECK ((hourly_rate > (0)::numeric))
);
    DROP TABLE public.employees;
       public         heap    postgres    false    6            �            1259    19207    orders    TABLE       CREATE TABLE public.orders (
    id integer NOT NULL,
    order_date date,
    work_hours integer,
    service_type integer,
    client_surname text,
    client_name text,
    client_patronymic text,
    client_birth_date date,
    pass_serial character varying(4),
    pass_number character varying(6),
    pass_release_date date,
    release_department text,
    client_phone_num text,
    email text,
    auto_reg_num integer,
    auto_mark text,
    auto_model text,
    release_country text,
    release_year date,
    master uuid
);
    DROP TABLE public.orders;
       public         heap    postgres    false    6            �            1259    19206    orders_id_seq    SEQUENCE     �   CREATE SEQUENCE public.orders_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 $   DROP SEQUENCE public.orders_id_seq;
       public          postgres    false    6    220            �           0    0    orders_id_seq    SEQUENCE OWNED BY     ?   ALTER SEQUENCE public.orders_id_seq OWNED BY public.orders.id;
          public          postgres    false    219            �            1259    19246    services    TABLE     p   CREATE TABLE public.services (
    id integer NOT NULL,
    service_name text,
    current_cost numeric(9,2)
);
    DROP TABLE public.services;
       public         heap    postgres    false    6            �            1259    19245    services_id_seq    SEQUENCE     �   CREATE SEQUENCE public.services_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 &   DROP SEQUENCE public.services_id_seq;
       public          postgres    false    6    223            �           0    0    services_id_seq    SEQUENCE OWNED BY     C   ALTER SEQUENCE public.services_id_seq OWNED BY public.services.id;
          public          postgres    false    222            3           2604    19255    HistoryCost id    DEFAULT     t   ALTER TABLE ONLY public."HistoryCost" ALTER COLUMN id SET DEFAULT nextval('public."HistoryCost_id_seq"'::regclass);
 ?   ALTER TABLE public."HistoryCost" ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    224    221            0           2604    18982    email_validity_results id    DEFAULT     �   ALTER TABLE ONLY public.email_validity_results ALTER COLUMN id SET DEFAULT nextval('public.email_validity_results_id_seq'::regclass);
 H   ALTER TABLE public.email_validity_results ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    217    216            2           2604    19210 	   orders id    DEFAULT     f   ALTER TABLE ONLY public.orders ALTER COLUMN id SET DEFAULT nextval('public.orders_id_seq'::regclass);
 8   ALTER TABLE public.orders ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    219    220    220            4           2604    19249    services id    DEFAULT     j   ALTER TABLE ONLY public.services ALTER COLUMN id SET DEFAULT nextval('public.services_id_seq'::regclass);
 :   ALTER TABLE public.services ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    222    223    223            �          0    19232    HistoryCost 
   TABLE DATA           ^   COPY public."HistoryCost" (change_date, service_id, old_cost, new_cost, id, test) FROM stdin;
    public          postgres    false    221   �6       �          0    18975    email_validity_results 
   TABLE DATA           E   COPY public.email_validity_results (id, email, is_valid) FROM stdin;
    public          postgres    false    216   I7       �          0    19199 	   employees 
   TABLE DATA           �   COPY public.employees (id, surname, name, patronymic, "position", birth_date, phone, address_city, address_street, address_house, address_apartment, hourly_rate) FROM stdin;
    public          postgres    false    218   �7       �          0    19207    orders 
   TABLE DATA           3  COPY public.orders (id, order_date, work_hours, service_type, client_surname, client_name, client_patronymic, client_birth_date, pass_serial, pass_number, pass_release_date, release_department, client_phone_num, email, auto_reg_num, auto_mark, auto_model, release_country, release_year, master) FROM stdin;
    public          postgres    false    220   �8       �          0    19246    services 
   TABLE DATA           B   COPY public.services (id, service_name, current_cost) FROM stdin;
    public          postgres    false    223   �9       �           0    0    HistoryCost_id_seq    SEQUENCE SET     B   SELECT pg_catalog.setval('public."HistoryCost_id_seq"', 2, true);
          public          postgres    false    224            �           0    0    email_validity_results_id_seq    SEQUENCE SET     L   SELECT pg_catalog.setval('public.email_validity_results_id_seq', 28, true);
          public          postgres    false    217            �           0    0    orders_id_seq    SEQUENCE SET     ;   SELECT pg_catalog.setval('public.orders_id_seq', 2, true);
          public          postgres    false    219            �           0    0    services_id_seq    SEQUENCE SET     =   SELECT pg_catalog.setval('public.services_id_seq', 2, true);
          public          postgres    false    222            =           2606    19260    HistoryCost HistoryCost_pkey 
   CONSTRAINT     ^   ALTER TABLE ONLY public."HistoryCost"
    ADD CONSTRAINT "HistoryCost_pkey" PRIMARY KEY (id);
 J   ALTER TABLE ONLY public."HistoryCost" DROP CONSTRAINT "HistoryCost_pkey";
       public            postgres    false    221            7           2606    18986 2   email_validity_results email_validity_results_pkey 
   CONSTRAINT     p   ALTER TABLE ONLY public.email_validity_results
    ADD CONSTRAINT email_validity_results_pkey PRIMARY KEY (id);
 \   ALTER TABLE ONLY public.email_validity_results DROP CONSTRAINT email_validity_results_pkey;
       public            postgres    false    216            9           2606    19205    employees employees_pkey 
   CONSTRAINT     V   ALTER TABLE ONLY public.employees
    ADD CONSTRAINT employees_pkey PRIMARY KEY (id);
 B   ALTER TABLE ONLY public.employees DROP CONSTRAINT employees_pkey;
       public            postgres    false    218            ;           2606    19214    orders orders_pkey 
   CONSTRAINT     P   ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_pkey PRIMARY KEY (id);
 <   ALTER TABLE ONLY public.orders DROP CONSTRAINT orders_pkey;
       public            postgres    false    220            ?           2606    19253    services services_pkey 
   CONSTRAINT     T   ALTER TABLE ONLY public.services
    ADD CONSTRAINT services_pkey PRIMARY KEY (id);
 @   ALTER TABLE ONLY public.services DROP CONSTRAINT services_pkey;
       public            postgres    false    223            B           2620    19266    services price_change_trigger    TRIGGER     �   CREATE TRIGGER price_change_trigger AFTER UPDATE OF current_cost ON public.services FOR EACH ROW WHEN ((old.current_cost IS DISTINCT FROM new.current_cost)) EXECUTE FUNCTION public.log_price_change();
 6   DROP TRIGGER price_change_trigger ON public.services;
       public          postgres    false    223    223    223    226            @           2606    19215    orders master_fk    FK CONSTRAINT     |   ALTER TABLE ONLY public.orders
    ADD CONSTRAINT master_fk FOREIGN KEY (master) REFERENCES public.employees(id) NOT VALID;
 :   ALTER TABLE ONLY public.orders DROP CONSTRAINT master_fk;
       public          postgres    false    220    4665    218            A           2606    19267    HistoryCost service_fk    FK CONSTRAINT     �   ALTER TABLE ONLY public."HistoryCost"
    ADD CONSTRAINT service_fk FOREIGN KEY (service_id) REFERENCES public.services(id) NOT VALID;
 B   ALTER TABLE ONLY public."HistoryCost" DROP CONSTRAINT service_fk;
       public          postgres    false    221    223    4671            �   M   x�3202�50�54���41500�30�44�2���\FE�� %`)�b��.n��}��B�ō�B.q��\1z\\\ �iJ      �   �   x�u�K
�0е}���ҍ�faǡi>�oK���Ao3 �s�S�<��&@j1�X�iL���|{#���4�u�>-Ŏ���@qdpO0tT04���-�����#�}c����׺��-���=��Q<��4<�򦤔��      �   �   x�U�;
1E뗽dx����&Af�������:��fG����ܟO6��7Ҍ�J�Xɠ��6:�9���pC�����X�pE���o��ԣO��V�_)f�i"<�7�x�ᎹVL�<)Ҏf��_��N6      �     x��ϽJA�z�]6��~�+�4����G�@.���R�BD�BP���o��酳�?�.;��H�U�+����y�k��o�?]��;���Ҥ�+$c�Om�
=�+?�乼t�H�p�
ˣrܛ΁�98�\/&0��gp:��*�c>�"/����[e��)7���#3�u6)�x�y��x�cW�6d�&����q�Ǜ��E���o�/��Q'pR]5U�8�Fǃ��V�;�v��t�,˾��      �   3   x�3�0�{.l���������^l��������@���+F��� V�     