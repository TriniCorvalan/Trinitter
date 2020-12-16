# Proyecto Twitter

** [Heroku link] (https://trinitter.herokuapp.com/) **

## Hito 1

Para comenzar hay que crear el proyecto en rails en el terminal.
Para poder subirlo a heroku hay que iniciar la base de datos como postgresql.

```console
$ rails new nombre_app -d=postgresql
$ rails db:create
```

---


### Historia 1

-[x] Una visita debe poder registrarse utilizando el link de registro en la barra de navegación.
-[x] La visita al registrarse debe ingresar nombre usuario, foto de perfil (url), email y password.
-[x] El modelo debe llamarse user.
-[x] Si una visita ya tiene usuario deberá utilizar el link de ingreso y llenará los campos: email y password antes de hacer click en ingresar.
-[x] Al registrarse o ingresar se le debe redirigir a la página de inicio y mostrar una alerta con el mensaje de "bienvenido".

Para lo completar lo anterior se puede usar la gema devise.
Para poder utilizarla debemos integrar **devise** al archivo `Gemfile` en la carpeta raiz del proyecto.

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

```ruby
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

```ruby
<div class="field">
    <%= f.label :username %><br />
    <%= f.text_field :username, autocomplete: "username" %>
  </div>

  <div class="field">
    <%= f.label :photo %><br />
    <%= f.text_field :photo, autocomplete: "photo" %>
  </div>
```

Para configurar el mensaje de bienvenida, hay que editarlo en el archivo `/Users/trini/Desktop/proyecto/1/twitter/config/locales/devise.en.yml``

```yml
en:
  devise:
    registrations:
      signed_up: "Bienvenido@"
      ...
    sessions:
      signed_in: "Bienvenido@"
```

---

### Historia 2