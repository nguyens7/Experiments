library(DiagrammeR)

# Version 1
grViz("
      digraph dot {
        
        graph [layout = dot,
               rankdir = LR]
        
        node [shape = Box,
              style = filled,
              color = Black,
              fontname = Helvetica,
              penwidth = 2.0]
        
        node [fillcolor = Plum]
        
        c [label = 'nanoimport'];
        d [label = 'nanotidy'];
        k [label = 'nanocount'];
        l [label = 'nanonest'];
        q [label = 'nanoShapiro'];
        m [label = 'nANOVA'];
        n [label = 'nanoTtest'];
        o [label = 'nanolyze'];
        
        
        node [fillcolor= GhostWhite]    
        
        a [label = 'Raw Nanosight Data'];
        b [label = 'User Cleaned Data '];
        i [label = 'base R statistics'];
        
        node [fillcolor = Cyan2]
  
        e [label = 'dplyr'];    
        h [label = 'tidy data'];
        
        node [shape = circle,
              style = filled,
              color = Black,
              fontname = Helvetica,
              penwidth = 2.0,
              width = 1]

        node [fillcolor = Cyan2]
        
        j [label = 'ggplot2'];

        node [fillcolor = Plum]
        
        p [label = 'nanoShiny'];
        
        a->c
        a->b
        b-> d
        c->d->e->h->k->o->j
        h->e
        h->{i j p l}
        l->{m n q}
        
      }")




# Version 2

grViz("
      digraph dot {
      
      graph [layout = dot,
      rankdir = LR]
      
      node [shape = Box,
      style = filled,
      color = Black,
      fontname = Helvetica,
      penwidth = 2.0]
      
      node [fillcolor = Plum]
      
      c [label = 'nanoimport'];
      d [label = 'nanotidy'];
      k [label = 'nanocount'];
      l [label = 'nanonest'];
      q [label = 'nanoShapiro'];
      o [label = 'nanolyze'];
      
      
      node [fillcolor= GhostWhite]    
      
      a [label = 'Raw Nanosight Data'];
      b [label = 'User Cleaned Data '];
      i [label = 'base R statistics'];
      
      node [fillcolor = Cyan2]
      
      e [label = 'dplyr'];    
      h [label = 'tidy data'];
      m [label = 'broom'];
      
      node [shape = circle,
      style = filled,
      color = Black,
      fontname = Helvetica,
      penwidth = 2.0,
      width = 1]
      
      node [fillcolor = Cyan2]
      
      j [label = 'ggplot2'];

      node [fillcolor = Plum]
      
      p [label = 'shinySIGHT'];
      
      a->c
      a->b
      b-> d
      c->d->e->h->k->o->j
      h->{e o i j l}
      l->q
      q->e->i->m
      {k o}->l
      h->p
      
      }")




# Version 3

grViz("
      digraph dot {
      
      graph [layout = dot,
      rankdir = LR]
      
      node [shape = Box,
      style = filled,
      color = Black,
      fontname = Helvetica,
      penwidth = 2.0]
      
      node [fillcolor = Plum]
      
      c [label = 'nanoimport'];
      d [label = 'nanotidy'];
      k [label = 'nanocount'];
      l [label = 'nanonest'];
      q [label = 'nanoShapiro'];
      o [label = 'nanolyze'];
      
      
      node [fillcolor= GhostWhite]    
      
      a [label = 'Raw Nanosight Data'];
      b [label = 'User Cleaned Data '];
      i [label = 'base R statistics'];
      
      node [fillcolor = Cyan2]
      
      e [label = 'dplyr'];    
      h [label = 'tidy data'];
      m [label = 'broom'];
      
      node [shape = circle,
      style = filled,
      color = Black,
      fontname = Helvetica,
      penwidth = 2.0,
      width = 1]
      
      node [fillcolor = Cyan2]
      
      j [label = 'ggplot2'];
      
      node [fillcolor = Plum]
      
      p [label = 'shinySIGHT'];
      
      a->c
      a->b
      b-> d
      c->d->e->h->k->o->j
      h->{e o i j l}
      l->q->h
      i->m
      {k o}->l
      h->p
      
      }")

# Version 4

grViz("
      digraph dot {
      
      graph [layout = dot,
      rankdir = LR]
      
      node [shape = Box,
      style = filled,
      color = Black,
      fontname = Helvetica,
      penwidth = 2.0]
      
      node [fillcolor = Plum]
      
      a [label = 'nanoimport()'];
      b [label = 'nanotidy()'];
      c [label = 'nanocount()\nnanolyze()\nnanonest()\nnanoShapiro()'];

  
      node [fillcolor= GhostWhite]    
      
      d [label = 'Raw Nanosight Data'];
      e [label = 'User Cleaned Data '];
      f [label = 'base R statistics'];
      
      node [fillcolor = Cyan2]
      
      g [label = 'dplyr'];    
      h [label = 'tidy data'];
      i [label = 'broom'];
      
      node [shape = circle,
      style = filled,
      color = Black,
      fontname = Helvetica,
      penwidth = 2.0,
      width = 1]
      
      node [fillcolor = Cyan2]
      
      j [label = 'ggplot2'];
      
      node [fillcolor = Plum]
      
      k [label = 'shinySIGHT'];


      d->e->b
      d->a->b->g->h->{j k f g c}
      f->i
      c->{f j}
      }")