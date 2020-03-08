import React from 'react'

import ArticleItem from 'packs/components/articles/items/article'
import StoryItem from 'packs/components/articles/items/story'
import ArticlesGroupItem from 'packs/components/articles/items/articles_group'

export const ITEM_TYPES = {
  ARTICLE: 'article',
  STORY: 'story',
  ARTICLES_GROUP: 'articles_group'
}

export const buildItemComponent = (item) => {
  switch(item.type) {
    case ITEM_TYPES.ARTICLE:
      return <ArticleItem key={item.id} target={item} />
    case ITEM_TYPES.STORY:
      return <StoryItem key={item.id} target={item} />
    case ITEM_TYPES.ARTICLES_GROUP:
      return <ArticlesGroupItem  key={item.value} target={item} />
  }
}
