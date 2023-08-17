

## Create Azure Account

I created a free account, electing the $200 free option.  In the entire exercise, I used less than $2 of my allotment.

&nbsp;

## Resource Groups

A key concept in all of the steps below is a `Resource Group`, which manages the multiple containers and resources (databases, storage etc) that comprise your system.  

For more information, [click here](https://learn.microsoft.com/en-us/azure/azure-resource-manager/management/manage-resource-groups-portal){:target="_blank" rel="noopener"}.

&nbsp;

## Managing your Account

There are several ways of creating applications.  Key ones are noted below.

&nbsp;

### Portal CLI

You can log into the Azure Portal, and access the CLI like this:

![Azure Data Tools](images/docker/azure/portal.png)

&nbsp;

### Local az CLI

You can install the CLI locally, as [described here](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli){:target="_blank" rel="noopener"}.

&nbsp;

### Azure UI

The Azure Portal also offers many UI options to create accounts, databases, etc.





&nbsp;

## Trouble Shooting

Use this command to view Azure logs:

```bash
az container logs --resource-group myResourceGroup --name mycontainer
```

For specific error conditions, see [Troubleshooting Azure](../Troubleshooting/#azure-cloud-deployment){:target="_blank" rel="noopener"}.
