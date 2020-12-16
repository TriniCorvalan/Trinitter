# Proyecto Twitter

**[Heroku link](https://trinitter.herokuapp.com/)**

---

### Índice

+ [Proyecto base](#proyecto-base)
    + [Crear el proyecto](#crear-el-proyeto)
    + [Agregar Bootstrap](#agregar-bootstrap)
    + [Navbar](#navbar)

+ [Hito 1](#hito-1)
    + [1. Historia 1](#1-historia-1) 
    + [1. Historia 2](#1-historia-2)
    + [1. Historia 3](#1-historia-3)
    + [1. Historia 4](#1-historia-4)
    + [1. Historia 5](#1-historia-5)
    + [1. Historia 6](#1-historia-6)
    + [1. Historia 7](#1-historia-7)

---

### Proyecto base

#### crear el proyecto

Se debe crear el proyecto en rails en el terminal.
Para poder subirlo a heroku hay que iniciar la base de datos como postgresql y luego crearla.

```console
$ rails new nombre_app -d=postgresql
$ rails db:create
```

#### Agregar Bootstrap

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

#### Navbar

Usando los templates de Bootstrap, se crea una vista parcial con el navbar que se guarda en `app/views/shared/_navbar.html.erb` 

Luego se llama desde `app/views/layouts/application.html.erb` al comienzo del `<body>` usando 

```ruby
    <%= render 'shared/navbar' %>
```

---


## Hito 1


---

### 1. Historia 1

- _Una visita debe poder registrarse utilizando el link de registro en la barra de navegación._
- _La visita al registrarse debe ingresar nombre usuario, foto de perfil (url), email y password._
- _El modelo debe llamarse user._
- _Si una visita ya tiene usuario deberá utilizar el link de ingreso y llenará los campos: email y password antes de hacer click en ingresar._
- _Al registrarse o ingresar se le debe redirigir a la página de inicio y mostrar una alerta con el mensaje de "bienvenido"._

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

```ruby
    <% if notice %>
        <%= notice %>
    <% end %>
    <% if alert %>
        <%= alert %>
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

```ruby
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

### 1. Historia 2

- _Una visita debe poder entrar a la página de inicio y ver los últimos 50 tweets._
- _Cada tweet debe mostrar el contenido, la foto del autor (url a la foto), la cantidad de likes y la cantidad de retweets._
- _Los modelos debe llamarse tweet y like._

Se debe crear el modelo `Tweet`, este tendrá un contenido (tipo string) y un user_id que referencia a quien creo ese tweet. 

```console
$ rails g model tweet content user:belongs_to
```

Revisamos y cargamos la migración  

```console
$ rails db:migrate
```

Agregamos el método `has_many` al modelo User para generar la asociación
Aprovecharemos de agregar el metodo `to_s` como username

```ruby
class User < ApplicationRecord
  ...

  has_many :tweets

  def to_s
    username
  end
  
end
```

y el método `belong_to` al modelo Tweet

```ruby
class Tweet < ApplicationRecord
  
  belongs_to :user

end
```

Luego se crea el modelo `Like` que tiene un tweet_id (referencia de tweet al que se le dio like) y un user_id (referencia al usuario que dio el like)

```console
$ rails g model like tweet:belongs_to user:belongs_to
```

Revisamos y cargamos la migración  

```console
$ rails db:migrate
```

y a los modelos `app/models/like.rb`, `../tweet.rb` y `../user.rb` se les agrega la relación y también la validación que hace única la relación tweet-user-like

```ruby
class Like < ApplicationRecord
  belongs_to :user
  belongs_to :tweet

  validates :user_id, uniqueness: {scope: :tweet_id}
end


class Tweet < ApplicationRecord
  ...
  has_many :likes
end 


class User < ApplicationRecord
  ...

  has_many :likes

  ...
end
```

Para crear la acción retweet, se puede agregar una columna al modelo `Tweet` de referencia al mismo modelo

```console
$ rails g migration AddTweetRefToTweet tweet:references
```

Revisamos y cargamos la migración  

```console
$ rails db:migrate
```

y se agrega las asociaciones al modelo `Tweet`

```ruby
class Tweet < ApplicationRecord
  ...

  belongs_to :tweet, class_name: 'Tweet', optional: true
  has_many :tweets, foreign_key: :tweet_id, class_name: 'Tweet'
end
```

Se necesita un controlador para el modelo Tweet con al menos el `index`

```console
$ rails g controller tweets index
```

En el controlador `app/controllers/tweets_controller.rb` se especifica que `@tweets` serán todos los tweets (para así poder llamarlos en la vista)

```ruby
class TweetsController < ApplicationController

  def index
    @tweets = Tweet.all
  end

end
```

En la vista `app/views/tweets/index.html.erb` se iteran los tweets para ir mostrándolos.

```ruby
<% @tweets.each do |tweet| %>
    <%= tweet.content %>
    <%= link_to(image_tag(tweet.user.photo), tweet) %>
    <%= tweet.user %>
    <%= tweet.likes.count %>
    <%= tweet.tweets.count %>
<% end %>
```

---

### 1. Historia 3

- _Estos tweets deben estar paginados y debe haber un link llamado "mostrar más tweets", al presionarlo nos llevará a los siguientes 50 tweets._


Para paginar los tweets se puede usar la gema `kaminari`. Para usarla se debe agregar al `Gemfile`

```ruby
gem 'kaminari'
```

Luego en el método del controlador (en este caso index) cambiamos por

```ruby
def index
    @tweets = Tweet.order('created_at DESC').page(params[:page]).per(50)
end
```

Y se invoca el metodo `paginate` en la vista

```ruby
<%= paginate @tweets %>
```

Para modificiar los mensajes que aparecen en el paginador se cambia en `config/locales/en.yml` 

```yml
en:
  hello: "Hello world"
  views:
    pagination:
      first: 'First'
      previous: 'atrás'
      next: 'mostrar más tweets'
      last: 'Last'
```

---

### 1. Historia 4

- _Al principio de la página debe haber una formulario que nos permita ingresar un nuevo tweet, al crear un tweet el usuario será redirigido a la página de inicio._
- _El formulario solo debe mostarse a los usuarios y no a las visitas._
- _Se debe validar que el tweet tenga contenido._

---

### 1. Historia 5

- _Un usuario puede hacer like en un tweet, al hacerlo será redirigido a la página de inicio_
- _Se debe mostrar un icono distinto para cuando un usuario ha hecho like._
- _Un usuario no puede hacer dos likes sobre el mismo tweet. Por lo tanto, se le debe quitar el like en el caso de que vuelva a hacer click en el botón._

Para agregar los likes, se debe generar los métodos de like y dislike en el controlador `app/controllers/tweets_controller.rb` que crearan y destruiran el like

```ruby
  def like
    Like.create(user_id: current_user.id, tweet_id: @tweet.id)
    redirect_to root_path
  end

  def dislike
    Like.find_by(user_id: current_user.id, tweet_id: @tweet.id).destroy
    redirect_to root_path
  end
```

Se deben agregar las rutas de estos nuevos métodos en `config/routes.rb`

```ruby
put 'tweet/:id/like', to: 'tweets#like', as: 'like'
delete 'tweet/:id/dislike', to: 'tweets#dislike', as: 'dislike'
```

---

### 1. Historia 6

- _Un usuario puede hacer un retweet haciendo click en la acción rt (retweet) de un tweet, esto hará que ingrese un nuevo tweet con el mismo contenido pero además referenciando al tweet original_

---

### 1. Historia 7

- _Haciendo click en la fecha del tweet se debe ir al detalle del tweet y dentro del detalle debe aparecer la foto de todas las personas que han dado like al tweet._
- _La fecha del tweet debe aparecer como tiempo en minutos desde la fecha de creación u horas si es mayor de 60 minutos._