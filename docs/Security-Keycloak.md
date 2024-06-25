!!! pied-piper ":bulb: TL;DR - Authorize using Keycloak"

    You can use Keycloak for authentication.  You can configure your own keycloak, or use the procedure below to
    
    1. Install keycloak using a Docker container: `cd devops/keycloak; docker compose up`

    2. Activate: `als add-auth --provider-type=keycloak --db-url=localhost`

    This page is ***under construction***.  

&nbsp;

## Keycloak: `local` config

Use this procedure to install and configure a local version of keycloak, running under Docker.

&nbsp;

### Install and Configure

Projects are pre-created with scripts start Keycloak under Docker.

To activate keycloak running under a docker container:

1. Install Keycloak with Docker (imports settings from `devops/keycloak/data/import`):

![kc-user-roles](images/keycloak/kc-config-local-install-kc.png)

2. Configure your project

```bash title='Configure Keycloak - local'
als add-auth --provider-type=keycloak --db-url=localhost
```

<details markdown>

<summary>Internals - verify admin Configuration </summary>

The config settings for the admin app are set in `ui/admin/admin_loader.py`.  This reduces the number of settings to change when altering your configuration.  You can verify them as shown below:

![kc-user-roles](images/keycloak/admin-config.png)

</details>

![kc-user-roles](images/keycloak/kc-config-local.png)

&nbsp;

### Verify

You should now be able to run the admin app:

1. login as **s1/p** -- note the login screen indicates *kcals*:

![kc-user-roles](images/keycloak/kc-login-local.png)

2. Verify there is only 1 customer

3. Logout and login as **admin/p**, and there should be more customers

&nbsp;

## Keycloak Admin

You can use the [Keycloak admin console](http://localhost:8080/){:target="_blank" rel="noopener"} to define Users and their Roles / Attributes.

&nbsp;

### User Administration

To define Users and their Roles / Attributes:

1. Note the selected realm (`kcals`)

![kc-users](images/keycloak/kc-users.png)

### User Roles

Define Roles for your realm:

![kc-roles](images/keycloak/kc-roles.png)

&nbsp;

And assign them to users:

![kc-user-roles](images/keycloak/kc-user-roles.png)

### User Attributes

#### Valid Attributes

First, define attributes types:

![kc-dedicated-scopes](images/keycloak/kc-client-attr-mapper-def.png)

#### Link Attributes to Scopes

![kc-client-attr-mapper](images/keycloak/clients-dedicated-scopes.png)

#### Assign User Attribute Values

![kc-attrs](images/keycloak/kc-attrs.png)

&nbsp;

### Export Auth Data

After defining your users, attributes and roles, you will want to save this keycloak auth data into your project, for source control and sharing.

Export your revised auth data:

1. In the terminal window of your project:

```bash title='Export the revised auth data'
% docker exec -it keycloak bash

$ cd /opt/keycloak
$ bin/kc.sh export --help
$ bin/kc.sh export --dir export
$ exit
```

This creates a directory *in the keycloak docker:* `keycloak:/opt/keycloak/export`.  We can import this back into our project, as described next.

&nbsp;

### Use Exported Auth Data in Project

You can make this saved auth data part of your project (and saved to `git` for your team), as follows:

1. In the terminal window of your project

```bash title='Use Exported Auth Data in Project'
mv devops/keycloak/import-save devops/keycloak/import-backup
docker cp keycloak:/opt/keycloak/export devops/keycloak/import
```


# Appendix

## Internals

Authentication and the keycloak provider interact as shown below:

![keycloak provider](images/keycloak/integrate-keycloak.png)

## Inspecting Access Tokens

You can use jwt.io:

![jwt.io](images/keycloak/jwt.io.png)
