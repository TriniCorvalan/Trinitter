# Proyecto Twitter

**[Heroku link](https://trinitter.herokuapp.com/)**

---

### Índice

+ [Proyecto base](#inicio)
    + [Crear el proyecto](#inicio)
    + [Agregar Bootstrap](#bootstrap)
    + [Navbar](#navbar)

+ [Hito 1](#1)
    + [Historia 1](#1historia1) 
    + [Historia 2](#1historia2)
    + [Historia 3](#1historia3)
    + [Historia 4](#1historia4)
    + [Historia 5](#1historia5)
    + [Historia 6](#1historia6)
    + [Historia 7](#1historia7)

---

### Proyecto base {:#inicio}

#### crear el proyecto

Se debe crear el proyecto en rails en el terminal.
Para poder subirlo a heroku hay que iniciar la base de datos como postgresql y luego crearla.

```console
$ rails new nombre_app -d=postgresql
$ rails db:create
```

#### Agregar Bootstrap {:#bootstrap}.

Para esto se debe integrar Bootstrap y jQuery en el archivo `Gemfile` en la carpeta raíz del proyecto.

```ruby
gem 'bootstrap', '4.3.1'
gem 'jquery-rails'
```

Correr el **bundle** en el terminal para cargar la gema.

```console
$ bundle
```

Importar bootstrap en `app/assets/stylesheets/application.scss`

```scss
// Custom bootstrap variables must be set or imported *before* bootstrap.
@import "bootstrap";
```

_Hay que asegurarse que la extensión del archivo sea `.scss`, puede que por defecto sea `.css`, en ese caso hay que renombrarlo y remover todos los `*= require` y `*= require_tree` y usar `@import` para importar los otros archivos Sass `.scss`_

Agregar las dependencias de Bootstrap en `app/assets/javascripts/application.js` 

```js
//= require jquery3
//= require popper
//= require bootstrap
```

#### Navbar {#navbar}

Usando los templates de Bootstrap, se crea una vista parcial con el navbar que se guarda en `app/views/shared/_navbar.html.erb` 

Luego se llama desde `app/views/layouts/application.html.erb` al comienzo del `<body>` usando 

```ruby
    <%= render 'shared/navbar' %>
```

---


## Hito 1


---

### Historia 1 {:#1historia1}

- [x] Una visita debe poder registrarse utilizando el link de registro en la barra de navegación.
- [x] La visita al registrarse debe ingresar nombre usuario, foto de perfil (url), email y password.
- [x] El modelo debe llamarse user.
- [x] Si una visita ya tiene usuario deberá utilizar el link de ingreso y llenará los campos: email y password antes de hacer click en ingresar.
- [x] Al registrarse o ingresar se le debe redirigir a la página de inicio y mostrar una alerta con el mensaje de "bienvenido".

Para lo completar lo anterior se puede usar la gema devise.
Para poder utilizarla debemos integrar **devise** al archivo `Gemfile`.

```ruby 
gem 'devise'
```

luego correr el **bundle** en el terminal para cargar la gema.

```console
$ bundle
````

Después hay que correr el generador en el terminal.

```console
$ rails g devise:install
```

En este punto apareceran una serie de instrucciones en el terminal para setear la URL default para el mailer en cada ambiente. 
Se sugiere: en la carpeta `config/environments/development.rb` agregar  

```ruby
config.action_mailer.default_url_options = { host: 'localhost', port: 3000 }
```

Además, agregar las notice y alerts en `app/views/layouts/application.html.erb`

```html
    <% if notice %>
        <div class="alert alert-dismissible alert-success">
          <button type="button" class="close" data-dismiss="alert">&times;</button>
          <h4><%= notice %></h4>
        </div>
      <% end %>
      <% if alert %>
        <div class="alert alert-dismissible alert-success">
          <button type="button" class="close" data-dismiss="alert">&times;</button>
          <h4>Atención</h4>
          <p><%= alert %></p>
        </div>
    <% end %>
```

antes de 

```ruby
    <%= yield %>
```

Una vez seteado, se genera en el terminal el modelo (en este caso `User`) con devise.  

```console
$ rails g devise User
```

Revisamos y cargamos la migración  

```console
$ rails db:migrate
```

Para poder editar las vistas de devise debemos generarlas a través del terminal

```console
$ rails g devise:views
```

Aprovecharemos de generar los controladores para poder modificarlos más adelante

```console
$ rails generate devise:controllers users
```

También generaremos las rutas, agregándolas en `config/routes.rb` y especificando lo que modificaremos.

```ruby
  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }
```

Devise exige **solo email y password** para registrarse, por lo que debemos agregar **username y photo**. Estos campos los agregaremos como columnas al modelo `User` a través de una migración.  

```console
$ rails g migration AddColumnsToUser username photo
```

_En este caso no es necesario especificar el tipo de dato ya que ambos son por defecto `string`._

Revisamos y cargamos la migración  

```console
$ rails db:migrate
```

**Estos nuevos campos debemos agregarlos al formulario de registro.**

Editaremos el formulario de registro en `app/views/devise/registrations/new.html.erb` y `.../edit.html.erb` Agregando:

```html
<div class="field">
    <%= f.label :username %><br />
    <%= f.text_field :username, autocomplete: "username" %>
  </div>

  <div class="field">
    <%= f.label :photo %><br />
    <%= f.text_field :photo, autocomplete: "photo" %>
  </div>
```

Para configurar el mensaje de bienvenida, hay que editarlo en el archivo `/Users/trini/Desktop/proyecto/1/twitter/config/locales/devise.en.yml`

```yml
en:
  devise:
    registrations:
      signed_up: "Bienvenido@"
      ...
    sessions:
      signed_in: "Bienvenido@"
```

Para fijar los accesos se pueden agregar al un navbar a través del helper `link_to`
_Recordar revisar las rutas con_ `rails routes` _para poder asignarlo correctamente en el path_


Si el usuario ya inició sesión, se mostrarán accesos a su perfil, tweets y cerrar sesión.
En caso contrario, se mostrataran los accesos de registro e inicio de sesión. 

Para esto se usa el helper incluido en devise `user_signed_in?` de esta forma:

```html
    <ul class="navbar-nav" >
          <% if user_signed_in? %>
            <li class="nav-item"><%=link_to 'My Tweets', `home_tweets_path` %></li>
            <li class="nav-item"><%= link_to 'My Profile', `home_profile_path` %></li>
            <li role="separator" class="divider"></li>
            <li class="nav-item"><%= link_to 'Sign out', destroy_user_session_path, method: :delete %></li>
        <% else %>
            <li class="nav-item"><%= link_to 'Log in', user_session_path %></li>
            <li class="nav-item"><%= link_to 'Sign up', new_user_registration_path %></li>
      <% end  %>
    </ul>
```

---

### Historia 2 {:#1historia2}

---

### Historia 3 {:#1historia3}

---

### Historia 4 {:#1historia4}

---

### Historia 5 {:#1historia5}

---

### Historia 6 {:#1historia6}

---

### Historia 7 {:#1historia7}
