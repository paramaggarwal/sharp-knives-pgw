PGDMP     ;        
            w            pgw-main    9.5.17    10.9 Q    !	           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                       false            "	           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                       false            #	           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                       false            $	           1262    26595    pgw-main    DATABASE     |   CREATE DATABASE "pgw-main" WITH TEMPLATE = template0 ENCODING = 'UTF8' LC_COLLATE = 'en_US.UTF-8' LC_CTYPE = 'en_US.UTF-8';
    DROP DATABASE "pgw-main";
             pgw    false            	            2615    2200    public    SCHEMA        CREATE SCHEMA public;
    DROP SCHEMA public;
             postgres    false            %	           0    0    SCHEMA public    COMMENT     6   COMMENT ON SCHEMA public IS 'standard public schema';
                  postgres    false    9            &	           0    0    SCHEMA public    ACL     �   REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;
                  postgres    false    9                        3079    12361    plpgsql 	   EXTENSION     ?   CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;
    DROP EXTENSION plpgsql;
                  false            '	           0    0    EXTENSION plpgsql    COMMENT     @   COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';
                       false    1                        3079    26596    citext 	   EXTENSION     :   CREATE EXTENSION IF NOT EXISTS citext WITH SCHEMA public;
    DROP EXTENSION citext;
                  false    9            (	           0    0    EXTENSION citext    COMMENT     S   COMMENT ON EXTENSION citext IS 'data type for case-insensitive character strings';
                       false    3                        3079    26680    pgcrypto 	   EXTENSION     <   CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA public;
    DROP EXTENSION pgcrypto;
                  false    9            )	           0    0    EXTENSION pgcrypto    COMMENT     <   COMMENT ON EXTENSION pgcrypto IS 'cryptographic functions';
                       false    2            �           1247    26718    appointment_type    TYPE     �   CREATE TYPE public.appointment_type AS ENUM (
    'email',
    'phone',
    'text',
    'other',
    'in_person',
    'note'
);
 #   DROP TYPE public.appointment_type;
       public       pgw    false    9            �            1259    26731    ar_internal_metadata    TABLE     �   CREATE TABLE public.ar_internal_metadata (
    key character varying NOT NULL,
    value character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);
 (   DROP TABLE public.ar_internal_metadata;
       public         pgw    false    9            �            1259    34832    books    TABLE     �   CREATE TABLE public.books (
    id integer NOT NULL,
    name character varying NOT NULL,
    isbn uuid DEFAULT public.gen_random_uuid() NOT NULL,
    created_at timestamp without time zone DEFAULT now()
);
    DROP TABLE public.books;
       public         pgw    false    2    9    9            �            1259    34830    books_id_seq    SEQUENCE     u   CREATE SEQUENCE public.books_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 #   DROP SEQUENCE public.books_id_seq;
       public       pgw    false    9    188            *	           0    0    books_id_seq    SEQUENCE OWNED BY     =   ALTER SEQUENCE public.books_id_seq OWNED BY public.books.id;
            public       pgw    false    187            �            1259    34847    editions    TABLE     �   CREATE TABLE public.editions (
    id integer NOT NULL,
    name character varying NOT NULL,
    book_id integer NOT NULL,
    created_at timestamp without time zone DEFAULT now(),
    current boolean DEFAULT false
);
    DROP TABLE public.editions;
       public         pgw    false    9            �            1259    34845    editions_id_seq    SEQUENCE     x   CREATE SEQUENCE public.editions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 &   DROP SEQUENCE public.editions_id_seq;
       public       pgw    false    9    190            +	           0    0    editions_id_seq    SEQUENCE OWNED BY     C   ALTER SEQUENCE public.editions_id_seq OWNED BY public.editions.id;
            public       pgw    false    189            �            1259    34900    editions_shelves    TABLE     �   CREATE TABLE public.editions_shelves (
    id integer NOT NULL,
    edition_id integer NOT NULL,
    shelf_id integer NOT NULL,
    "position" integer NOT NULL,
    CONSTRAINT editions_shelves_position_check CHECK (("position" > 0))
);
 $   DROP TABLE public.editions_shelves;
       public         pgw    false    9            �            1259    34898    editions_shelves_id_seq    SEQUENCE     �   CREATE SEQUENCE public.editions_shelves_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 .   DROP SEQUENCE public.editions_shelves_id_seq;
       public       pgw    false    9    196            ,	           0    0    editions_shelves_id_seq    SEQUENCE OWNED BY     S   ALTER SEQUENCE public.editions_shelves_id_seq OWNED BY public.editions_shelves.id;
            public       pgw    false    195            �            1259    26940 	   employees    TABLE     �   CREATE TABLE public.employees (
    id integer NOT NULL,
    name character varying,
    manager_id integer,
    ceo boolean DEFAULT false,
    CONSTRAINT manager_required CHECK ((ceo OR (manager_id IS NOT NULL)))
);
    DROP TABLE public.employees;
       public         pgw    false    9            �            1259    26938    employees_id_seq    SEQUENCE     y   CREATE SEQUENCE public.employees_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 '   DROP SEQUENCE public.employees_id_seq;
       public       pgw    false    186    9            -	           0    0    employees_id_seq    SEQUENCE OWNED BY     E   ALTER SEQUENCE public.employees_id_seq OWNED BY public.employees.id;
            public       pgw    false    185            �            1259    26803    schema_migrations    TABLE     R   CREATE TABLE public.schema_migrations (
    version character varying NOT NULL
);
 %   DROP TABLE public.schema_migrations;
       public         pgw    false    9            �            1259    34889    shelves    TABLE     g   CREATE TABLE public.shelves (
    id integer NOT NULL,
    name text NOT NULL,
    description text
);
    DROP TABLE public.shelves;
       public         pgw    false    9            �            1259    34887    shelves_id_seq    SEQUENCE     w   CREATE SEQUENCE public.shelves_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 %   DROP SEQUENCE public.shelves_id_seq;
       public       pgw    false    9    194            .	           0    0    shelves_id_seq    SEQUENCE OWNED BY     A   ALTER SEQUENCE public.shelves_id_seq OWNED BY public.shelves.id;
            public       pgw    false    193            �            1259    34923    shelves_users    TABLE     �   CREATE TABLE public.shelves_users (
    id integer NOT NULL,
    shelf_id integer NOT NULL,
    user_id integer NOT NULL,
    description text
);
 !   DROP TABLE public.shelves_users;
       public         pgw    false    9            �            1259    34921    shelves_users_id_seq    SEQUENCE     }   CREATE SEQUENCE public.shelves_users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 +   DROP SEQUENCE public.shelves_users_id_seq;
       public       pgw    false    198    9            /	           0    0    shelves_users_id_seq    SEQUENCE OWNED BY     M   ALTER SEQUENCE public.shelves_users_id_seq OWNED BY public.shelves_users.id;
            public       pgw    false    197            �            1259    34875    users    TABLE     �   CREATE TABLE public.users (
    id integer NOT NULL,
    login character varying NOT NULL,
    email text NOT NULL,
    created_at timestamp without time zone DEFAULT now()
);
    DROP TABLE public.users;
       public         pgw    false    9            �            1259    34873    users_id_seq    SEQUENCE     u   CREATE SEQUENCE public.users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 #   DROP SEQUENCE public.users_id_seq;
       public       pgw    false    192    9            0	           0    0    users_id_seq    SEQUENCE OWNED BY     =   ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;
            public       pgw    false    191            m           2604    34835    books id    DEFAULT     d   ALTER TABLE ONLY public.books ALTER COLUMN id SET DEFAULT nextval('public.books_id_seq'::regclass);
 7   ALTER TABLE public.books ALTER COLUMN id DROP DEFAULT;
       public       pgw    false    188    187    188            p           2604    34850    editions id    DEFAULT     j   ALTER TABLE ONLY public.editions ALTER COLUMN id SET DEFAULT nextval('public.editions_id_seq'::regclass);
 :   ALTER TABLE public.editions ALTER COLUMN id DROP DEFAULT;
       public       pgw    false    190    189    190            v           2604    34903    editions_shelves id    DEFAULT     z   ALTER TABLE ONLY public.editions_shelves ALTER COLUMN id SET DEFAULT nextval('public.editions_shelves_id_seq'::regclass);
 B   ALTER TABLE public.editions_shelves ALTER COLUMN id DROP DEFAULT;
       public       pgw    false    196    195    196            j           2604    26943    employees id    DEFAULT     l   ALTER TABLE ONLY public.employees ALTER COLUMN id SET DEFAULT nextval('public.employees_id_seq'::regclass);
 ;   ALTER TABLE public.employees ALTER COLUMN id DROP DEFAULT;
       public       pgw    false    186    185    186            u           2604    34892 
   shelves id    DEFAULT     h   ALTER TABLE ONLY public.shelves ALTER COLUMN id SET DEFAULT nextval('public.shelves_id_seq'::regclass);
 9   ALTER TABLE public.shelves ALTER COLUMN id DROP DEFAULT;
       public       pgw    false    194    193    194            x           2604    34926    shelves_users id    DEFAULT     t   ALTER TABLE ONLY public.shelves_users ALTER COLUMN id SET DEFAULT nextval('public.shelves_users_id_seq'::regclass);
 ?   ALTER TABLE public.shelves_users ALTER COLUMN id DROP DEFAULT;
       public       pgw    false    198    197    198            s           2604    34878    users id    DEFAULT     d   ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);
 7   ALTER TABLE public.users ALTER COLUMN id DROP DEFAULT;
       public       pgw    false    192    191    192            	          0    26731    ar_internal_metadata 
   TABLE DATA               R   COPY public.ar_internal_metadata (key, value, created_at, updated_at) FROM stdin;
    public       pgw    false    183   PW       	          0    34832    books 
   TABLE DATA               ;   COPY public.books (id, name, isbn, created_at) FROM stdin;
    public       pgw    false    188   mW       	          0    34847    editions 
   TABLE DATA               J   COPY public.editions (id, name, book_id, created_at, current) FROM stdin;
    public       pgw    false    190   SY       	          0    34900    editions_shelves 
   TABLE DATA               P   COPY public.editions_shelves (id, edition_id, shelf_id, "position") FROM stdin;
    public       pgw    false    196   �[       	          0    26940 	   employees 
   TABLE DATA               >   COPY public.employees (id, name, manager_id, ceo) FROM stdin;
    public       pgw    false    186   �]       	          0    26803    schema_migrations 
   TABLE DATA               4   COPY public.schema_migrations (version) FROM stdin;
    public       pgw    false    184   /^       	          0    34889    shelves 
   TABLE DATA               8   COPY public.shelves (id, name, description) FROM stdin;
    public       pgw    false    194   L^       	          0    34923    shelves_users 
   TABLE DATA               K   COPY public.shelves_users (id, shelf_id, user_id, description) FROM stdin;
    public       pgw    false    198   �`       	          0    34875    users 
   TABLE DATA               =   COPY public.users (id, login, email, created_at) FROM stdin;
    public       pgw    false    192   !a       1	           0    0    books_id_seq    SEQUENCE SET     ;   SELECT pg_catalog.setval('public.books_id_seq', 10, true);
            public       pgw    false    187            2	           0    0    editions_id_seq    SEQUENCE SET     >   SELECT pg_catalog.setval('public.editions_id_seq', 32, true);
            public       pgw    false    189            3	           0    0    editions_shelves_id_seq    SEQUENCE SET     G   SELECT pg_catalog.setval('public.editions_shelves_id_seq', 115, true);
            public       pgw    false    195            4	           0    0    employees_id_seq    SEQUENCE SET     >   SELECT pg_catalog.setval('public.employees_id_seq', 3, true);
            public       pgw    false    185            5	           0    0    shelves_id_seq    SEQUENCE SET     =   SELECT pg_catalog.setval('public.shelves_id_seq', 15, true);
            public       pgw    false    193            6	           0    0    shelves_users_id_seq    SEQUENCE SET     C   SELECT pg_catalog.setval('public.shelves_users_id_seq', 37, true);
            public       pgw    false    197            7	           0    0    users_id_seq    SEQUENCE SET     ;   SELECT pg_catalog.setval('public.users_id_seq', 19, true);
            public       pgw    false    191            z           2606    26839 .   ar_internal_metadata ar_internal_metadata_pkey 
   CONSTRAINT     m   ALTER TABLE ONLY public.ar_internal_metadata
    ADD CONSTRAINT ar_internal_metadata_pkey PRIMARY KEY (key);
 X   ALTER TABLE ONLY public.ar_internal_metadata DROP CONSTRAINT ar_internal_metadata_pkey;
       public         pgw    false    183            �           2606    34920 -   editions_shelves books_are_ordered_in_a_shelf 
   CONSTRAINT     x   ALTER TABLE ONLY public.editions_shelves
    ADD CONSTRAINT books_are_ordered_in_a_shelf UNIQUE (shelf_id, "position");
 W   ALTER TABLE ONLY public.editions_shelves DROP CONSTRAINT books_are_ordered_in_a_shelf;
       public         pgw    false    196    196            �           2606    34844    books books_isbn_key 
   CONSTRAINT     O   ALTER TABLE ONLY public.books
    ADD CONSTRAINT books_isbn_key UNIQUE (isbn);
 >   ALTER TABLE ONLY public.books DROP CONSTRAINT books_isbn_key;
       public         pgw    false    188            �           2606    34842    books books_pkey 
   CONSTRAINT     N   ALTER TABLE ONLY public.books
    ADD CONSTRAINT books_pkey PRIMARY KEY (id);
 :   ALTER TABLE ONLY public.books DROP CONSTRAINT books_pkey;
       public         pgw    false    188            �           2606    34856    editions editions_pkey 
   CONSTRAINT     T   ALTER TABLE ONLY public.editions
    ADD CONSTRAINT editions_pkey PRIMARY KEY (id);
 @   ALTER TABLE ONLY public.editions DROP CONSTRAINT editions_pkey;
       public         pgw    false    190            �           2606    34906 &   editions_shelves editions_shelves_pkey 
   CONSTRAINT     d   ALTER TABLE ONLY public.editions_shelves
    ADD CONSTRAINT editions_shelves_pkey PRIMARY KEY (id);
 P   ALTER TABLE ONLY public.editions_shelves DROP CONSTRAINT editions_shelves_pkey;
       public         pgw    false    196            �           2606    34886    users email_must_be_unique 
   CONSTRAINT     q   ALTER TABLE ONLY public.users
    ADD CONSTRAINT email_must_be_unique EXCLUDE USING btree (lower(email) WITH =);
 D   ALTER TABLE ONLY public.users DROP CONSTRAINT email_must_be_unique;
       public         pgw    false    192            ~           2606    26949    employees employees_pkey 
   CONSTRAINT     V   ALTER TABLE ONLY public.employees
    ADD CONSTRAINT employees_pkey PRIMARY KEY (id);
 B   ALTER TABLE ONLY public.employees DROP CONSTRAINT employees_pkey;
       public         pgw    false    186            �           2606    34918 )   editions_shelves one_book_once_in_a_shelf 
   CONSTRAINT     t   ALTER TABLE ONLY public.editions_shelves
    ADD CONSTRAINT one_book_once_in_a_shelf UNIQUE (shelf_id, edition_id);
 S   ALTER TABLE ONLY public.editions_shelves DROP CONSTRAINT one_book_once_in_a_shelf;
       public         pgw    false    196    196            �           2606    34871 !   editions only_one_current_edition 
   CONSTRAINT     �   ALTER TABLE ONLY public.editions
    ADD CONSTRAINT only_one_current_edition EXCLUDE USING btree (book_id WITH =) WHERE ((current = true));
 K   ALTER TABLE ONLY public.editions DROP CONSTRAINT only_one_current_edition;
       public         pgw    false    190            |           2606    26871 (   schema_migrations schema_migrations_pkey 
   CONSTRAINT     k   ALTER TABLE ONLY public.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);
 R   ALTER TABLE ONLY public.schema_migrations DROP CONSTRAINT schema_migrations_pkey;
       public         pgw    false    184            �           2606    34897    shelves shelves_pkey 
   CONSTRAINT     R   ALTER TABLE ONLY public.shelves
    ADD CONSTRAINT shelves_pkey PRIMARY KEY (id);
 >   ALTER TABLE ONLY public.shelves DROP CONSTRAINT shelves_pkey;
       public         pgw    false    194            �           2606    34931     shelves_users shelves_users_pkey 
   CONSTRAINT     ^   ALTER TABLE ONLY public.shelves_users
    ADD CONSTRAINT shelves_users_pkey PRIMARY KEY (id);
 J   ALTER TABLE ONLY public.shelves_users DROP CONSTRAINT shelves_users_pkey;
       public         pgw    false    198            �           2606    34943 &   shelves_users shelves_users_uniqueness 
   CONSTRAINT     n   ALTER TABLE ONLY public.shelves_users
    ADD CONSTRAINT shelves_users_uniqueness UNIQUE (shelf_id, user_id);
 P   ALTER TABLE ONLY public.shelves_users DROP CONSTRAINT shelves_users_uniqueness;
       public         pgw    false    198    198            �           2606    34884    users users_pkey 
   CONSTRAINT     N   ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);
 :   ALTER TABLE ONLY public.users DROP CONSTRAINT users_pkey;
       public         pgw    false    192            �           2606    34857    editions editions_book_id_fkey    FK CONSTRAINT     }   ALTER TABLE ONLY public.editions
    ADD CONSTRAINT editions_book_id_fkey FOREIGN KEY (book_id) REFERENCES public.books(id);
 H   ALTER TABLE ONLY public.editions DROP CONSTRAINT editions_book_id_fkey;
       public       pgw    false    2178    188    190            �           2606    34907 1   editions_shelves editions_shelves_edition_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.editions_shelves
    ADD CONSTRAINT editions_shelves_edition_id_fkey FOREIGN KEY (edition_id) REFERENCES public.editions(id);
 [   ALTER TABLE ONLY public.editions_shelves DROP CONSTRAINT editions_shelves_edition_id_fkey;
       public       pgw    false    196    2180    190            �           2606    34912 /   editions_shelves editions_shelves_shelf_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.editions_shelves
    ADD CONSTRAINT editions_shelves_shelf_id_fkey FOREIGN KEY (shelf_id) REFERENCES public.shelves(id);
 Y   ALTER TABLE ONLY public.editions_shelves DROP CONSTRAINT editions_shelves_shelf_id_fkey;
       public       pgw    false    194    196    2188            �           2606    26950 #   employees employees_manager_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.employees
    ADD CONSTRAINT employees_manager_id_fkey FOREIGN KEY (manager_id) REFERENCES public.employees(id);
 M   ALTER TABLE ONLY public.employees DROP CONSTRAINT employees_manager_id_fkey;
       public       pgw    false    186    186    2174            �           2606    34932 )   shelves_users shelves_users_shelf_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.shelves_users
    ADD CONSTRAINT shelves_users_shelf_id_fkey FOREIGN KEY (shelf_id) REFERENCES public.shelves(id);
 S   ALTER TABLE ONLY public.shelves_users DROP CONSTRAINT shelves_users_shelf_id_fkey;
       public       pgw    false    2188    194    198            �           2606    34937 (   shelves_users shelves_users_user_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.shelves_users
    ADD CONSTRAINT shelves_users_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);
 R   ALTER TABLE ONLY public.shelves_users DROP CONSTRAINT shelves_users_user_id_fkey;
       public       pgw    false    192    198    2186            	      x������ � �      	   �  x�u��n1Ek�W��!Q���8�� A� i(�Z<�����wz@G��q������ӓ��N��۶u�R�V��c(�2S*��1�.��iv����a�'4�/�Re~�u5�l�!$��	P�J)ppRw3�cZB�ɛ�E���lg���NY�V(�rV8��)MǨ��y"�͟�u3%t�D"6R�|ȕ� R�I�Kab�S�����/���֑�=@�\��=��$������c9ri
�~���y�{;_e1U���*����`��z#/]����}�������}յ�����T�#pO
d�B�lG�q�Ԧ����S2OR_�ӧz].��s��d��`j�?�:�0���S$�8j86����懮��z�[���Pq���z]�j�a�u�X9@���H�Zp��cR�䬹���˟�aY��}U������6�1����5K�1�c&f����4M� 0�g      	   6  x�u�Mn�0���S�
�#�bv�� MZ$AW݌-��� )7���e.֡t%n�o�3����?8��A0nk�k�V��6�Vț��H8�|�8��G狰��&X�6:���w�4�D6�ڻjb��ޗ{[mU(x�4Uwntq@߁X�ۆ�<��oc�_(�J7�H�0v'7�����-�z�d+���--<bR���,g��N՚6;D��BQ���x��/SER�(x���Bn����G3cs�]J�˄C�'{�R\�.\����9�f��� g�8��X;_o0N-4���_��p��"�����K�eXqng���]�y�GG��B��:G���/�ל�k�j2kI�cO�'�Xa�y^�X=��N��.�P������]�Ղ�U����ae��q(7o�		���c�������c�;:�"�f����c��$}d9�B��o.LA�����S��b<��|/�������Y�ފ<%e�R��a��0:��\�%W�OI2�È]�}��eZ�,����TD�4y)�ǐ&,�������j����Sb      	   /  x�%TQ�C!�6�������؄7�(UI @m�\�gY-.���׺.b=��C��i�^'�W���ٺ���4���x�\W\��b��u���SX*$_D<'���V(�-���O�����r0
�C�M��CO�0|9���r��<Zi?rݡdV�:bZ�JH�<LE0vp]�)��Ҵx���d�)Df�[�-�r{�x� �"�I�$�!�������{�΃�
��\*Q*�"����᭠(b��&8�#�r*���3�K�G��!b
BU��V'��,�D�$oH�!�)_控1T<uE����Z�����{�;��4S��F*U��g4�+�B�-��<"�_ȫ�������$�r�Tk��3^dI�,��jB�V�+��`���V�D])2(�(Lt�mb��HU��0�T�Ԓt�j)u?zUC��1�/=v��9,��6CR^���@c�S,��u)M^��w5]{:�6�k�]�>*�%�������7#�C�ό�)�͔�OΘ����=�
�	5��IO�>大���8����b�� h3�/p��������      	   G   x�3���Up������,�2����ȫT�,K-�4�L�2��M,*�TH�+)VpI-�L���b���� x��      	      x������ � �      	   ,  x�]�ɮ�0E��W�j4o�L�
d�	M�놖�X�?/�ߗ2⩛��ȫ�ë�i�KVW��,����ڐT��j182�y�%��5��p���~#>t�(+�BW�ء��/��aA����(-�U�]���صd}��][���ɋ�k
�]d^�"��T[�G����.�*�Cd_�;X ȳ����/���K%��T4a�5��R��T���(:B�=5Ⱦ�FU�g�����)�Q�s(��u�6����|9E�� ?���o3�Yޡ%SZfp+Ƴ���dI��-۪�Gؚ�Q�L�9'�W�wEi*�Ȑ_3��Aw���.PK.2|^�V0���'����t�k��!��r�cTF&�A�E����ђ���}�򌺨�4 �p�w<���N�+�y'�l3���Ԙ���	��foa�Z�2�w��*g��k�o���y�C�[�|_�0v�R`��Z^s7�biL��y�G��m'w:���~E���9��s�E^3<��զ�b�|�l�[��3k�p��*���&���16�O�O%��5s��      	   �   x�-��1гS�j�6�L�uƜ�����of��ú4`5���6lJ�󛺜O��D����� 7?�O�4�Q���΢yzF����M�O3]��D�e���睡Dg�<X��>�O�������Z� ��5�      	     x�}SK��0]'��tD�ӫ���	.�"ĥ�D�~�z��l�@<��\�;%��m�v�q�((��a���^ޚ��H���DY��h?���.>����U���)e-���(x&��b�ei��e�ײ+&������ϳ'��E1_���୭Hp��IтxG�B�)� N�^���Ä�ћ��+^O늾�d'�"����e��v�����ﺢ��X|��D�`���=R��l�%B&u9��,J��CSK]�OG�Z��G�	��ҕ#?�o�Fj-r�-�Ib4�4z��Z몕���=s�7���?��G����V�������ʶ����E�C��iV��̈iFEi�7e�h��}�7�t{�-i��q5�U�~�C�u/u+�;�'����3
���P����W�潝�,�۶z��*m��q�K��%=�k�l�d��w����e�lõ��k[�R"�}�=(���=����η���IG��<�_�tE���RRʿ�%t     