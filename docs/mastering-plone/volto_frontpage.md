---
myst:
  html_meta:
    "description": "How to use the listing block with a custom criterion"
    "property=og:description": "How to use the listing block with a custom criterion"
    "property=og:title": "Creating a dynamic frontpage with Volto blocks"
    "keywords": "Volto, catalog, index, listing, criteria"
---

(volto-frontpage-label)=

# Creating a dynamic frontpage with Volto blocks

Show selected content on the front page by criterion.

````{card} Frontend chapter

Get the code: https://github.com/collective/ploneconf.site

```{note}
Despite this is a frontend chapter, we are working on backend code in `ploneconf.site`.
```

```shell
git checkout frontpage
```

More info in {doc}`code`
````


```{card}
In this part you will:

- Use a listing block to show content marked as "featured"
- Configure additional criterion for a listing block

Topics covered

- collection criterion
```


We prepared a behavior for content types to store the information if the content should be featured in the previous  chapter.
And we enhanced the catalog search by adding index and metadata "featured".
Now we turn this into a criterion for a listing block that shows featured content.


(volto-frontpage-criterion-label)=

## Add Index as collection criterion

To understand why we need a collection criterion for a dynamic frontpage in Volto and what a collection criterion is, we have to look at the listing block of Volto.

```{figure} _static/volto_frontpage.png
:alt: Listing Block sidebar
:align: left
```

In the sidebar we see the `criteria` selection and if we click there, it'll show some of the selectable criterions ordered in categories like the following:

- `Metadata` contains indexes that are counting as metadata like Type (means Portal Types) and Review State
- `Text` contains indexes that are counting as text-data like Description and Searchable Text
- `Dates` contains indexes which are working with date-data like Effective Date and Creation Date

To get all talks we marked as `featured` we have to get the listing block to recognize our newly created index.
This means we have to add our index to the collection criterions, so we can select it.

To add our new index as a criterion to be appliable in a listing block or a collection, we have to switch to our `backend`. There we have to create a plone.app.registry record for our index. This can be achieved by adding a new file {file}`profiles/default/registry/querystring.xml`:

```{code-block} xml
:linenos:

<?xml version="1.0"?>
<registry xmlns:i18n="http://xml.zope.org/namespaces/i18n"
          i18n:domain="plone">

  <records interface="plone.app.querystring.interfaces.IQueryField"
           prefix="plone.app.querystring.field.featured">
      <value key="title" i18n:translate="">Featured</value>
      <value key="enabled">True</value>
      <value key="sortable">False</value>
      <value key="operations">
          <element>plone.app.querystring.operation.boolean.isTrue</element>
          <element>plone.app.querystring.operation.boolean.isFalse</element>
      </value>
     <value key="group" i18n:translate="">Metadata</value>
  </records>

</registry>
```

To understand this code snippet, we have to know the information and tags we are using:

- The prefix `plone.app.querystring.field.featured` refers to the featured index we just created.
- The operations elements define the provided criterion values to filter the listing.
- The group value defines the group under which the entry shows up in the selection widget, in our case `Metadata`.

```{note}
For a list of existing QueryField declarations and operations see https://github.com/plone/plone.app.querystring/blob/master/plone/app/querystring/profiles/default/registry.xml
```

Like explained in the last chapter we can now restart the instance and import the newly added profile by using the `portal_setup` in our ZMI.


## Add a listing block to show the featured content

Now we will go back to our frontend.
To create a new listing block on the front-page we have to click on `edit` and then create one new block.
Now you choose the block `Listing` from the menu:

```{figure} _static/volto_frontpage_1.png
:alt: Most used blocks in Volto
:align: left
```

You will gain a new block and sidebar looking like this:

```{figure} _static/volto_frontpage_3.png
:alt: listing block with featured content
:align: left
```

## Outlook: block variations

The listing block comes with default variations for the display.
The editor can choose from these variations to change the template for the listing: with thumbnail image or without, etc..
Your project maybe needs a custom template. The way to go would be to create an additional variation of the listing block.
See {ref}`plone6docs:extensions-block-variations` for more information.
