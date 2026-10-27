@Comments
Feature: Crud de comments
    Background:
        * url 'https://gorest.co.in/public/v2'
        * header Accept = 'application/json'
        * header Content-Type = 'application/json'
        * header Authorization = 'Bearer 700d0c7a86eb84028bf5cd204b11587f812f9d7cd880dc4edbdbd1d407ae9954'
        * def req_headers = {Authorization: 'Bearer 700d0c7a86eb84028bf5cd204b11587f812f9d7cd880dc4edbdbd1d407ae9954'}
        * def dataGenerator = Java.type('Utils.DataGenerator')
        * def userPayload =
                """
                    {
                        "gender":"male", 
                        "status":"active"
                    }
                """
        * def randomUser = dataGenerator.getUserRandom()
        * userPayload.name = randomUser.name
        * userPayload.email = randomUser.email
    Scenario: Crear un comment a un posts
        Given path 'users'
        And headers req_headers
        And request userPayload
        When method post
        Then status 201
        * def userid = response.id
        * print userid

        Given path 'users', userid, 'posts'
        And headers req_headers
        And request
        """
        {
            "title": "creando posts",
            "body": "Gruñeme"
        }
        """
        When method post
        Then status 201
        * def postId = response.id
        * print postId
        
        Given path 'posts', postId, 'comments'
        And headers req_headers
        And request
        """
        {
            "name": "Agustincito",
            "email": "joseliito@example.com",
            "body": "Por que te mientes"
        }
        """
        When method post
        Then status 201
        And match response.body == "Por que te mientes"

    Scenario: Obtener comentarios de un posts
        Given path 'users'
        And headers req_headers
        And request userPayload
        When method post
        Then status 201
        * def userid = response.id
        * print userid

        Given path 'users', userid, 'posts'
        And headers req_headers
        And request
        """
        {
            "title": "creando posts",
            "body": "Gruñeme"
        }
        """
        When method post
        Then status 201
        * def postId = response.id
        * print postId
        
        Given path 'posts', postId, 'comments'
        And headers req_headers
        And request
        """
        {
            "name": "Agustincito",
            "email": "joseliito@example.com",
            "body": "Por que te mientes"
        }
        """
        When method post
        Then status 201
        And match response.body == "Por que te mientes"

        Given path 'posts', postId, 'comments'
        When method get
        Then status 200
