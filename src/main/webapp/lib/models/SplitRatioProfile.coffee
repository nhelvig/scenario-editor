  


<!DOCTYPE html>
<html>
  <head prefix="og: http://ogp.me/ns# fb: http://ogp.me/ns/fb# githubog: http://ogp.me/ns/fb/githubog#">
    <meta charset='utf-8'>
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <title>scenario-editor/src/main/webapp/lib/models/SplitratioProfile.coffee at crud · calpath/scenario-editor</title>
    <link rel="search" type="application/opensearchdescription+xml" href="/opensearch.xml" title="GitHub" />
    <link rel="fluid-icon" href="https://github.com/fluidicon.png" title="GitHub" />
    <link rel="apple-touch-icon" sizes="57x57" href="/apple-touch-icon-114.png" />
    <link rel="apple-touch-icon" sizes="114x114" href="/apple-touch-icon-114.png" />
    <link rel="apple-touch-icon" sizes="72x72" href="/apple-touch-icon-144.png" />
    <link rel="apple-touch-icon" sizes="144x144" href="/apple-touch-icon-144.png" />
    <link rel="logo" type="image/svg" href="http://github-media-downloads.s3.amazonaws.com/github-logo.svg" />
    <link rel="xhr-socket" href="/_sockets" />


    <meta name="msapplication-TileImage" content="/windows-tile.png" />
    <meta name="msapplication-TileColor" content="#ffffff" />
    <meta name="selected-link" value="repo_source" data-pjax-transient />
    <meta content="collector.githubapp.com" name="octolytics-host" /><meta content="github" name="octolytics-app-id" /><meta content="1514995" name="octolytics-actor-id" /><meta content="261a804abb877f7e665b547a43421ab7311f25597f5e5840925022a0c9724aa7" name="octolytics-actor-hash" />

    
    
    <link rel="icon" type="image/x-icon" href="/favicon.ico" />

    <meta content="authenticity_token" name="csrf-param" />
<meta content="mApFup2hp+yxBzATrsfKUeKx0KQy32Q8gJJ3JHoZU+U=" name="csrf-token" />

    <link href="https://a248.e.akamai.net/assets.github.com/assets/github-63cb089355e5b826c483075a050c52586f156b7b.css" media="all" rel="stylesheet" type="text/css" />
    <link href="https://a248.e.akamai.net/assets.github.com/assets/github2-36c8595c3a9674721acec1d66b013e5011aa4be0.css" media="all" rel="stylesheet" type="text/css" />
    


      <script src="https://a248.e.akamai.net/assets.github.com/assets/frameworks-92d138f450f2960501e28397a2f63b0f100590f0.js" type="text/javascript"></script>
      <script src="https://a248.e.akamai.net/assets.github.com/assets/github-25163394b02d1e289d7d250f14a829a2ca0f4861.js" type="text/javascript"></script>
      
      <meta http-equiv="x-pjax-version" content="c1cf086ec76fb03b2c4fad866074fb2a">

        <link data-pjax-transient rel='permalink' href='/calpath/scenario-editor/blob/8a03f820ffe93a029e33d87831aa3a5e3b1d8628/src/main/webapp/lib/models/SplitratioProfile.coffee'>
    <meta property="og:title" content="scenario-editor"/>
    <meta property="og:type" content="githubog:gitrepository"/>
    <meta property="og:url" content="https://github.com/calpath/scenario-editor"/>
    <meta property="og:image" content="https://secure.gravatar.com/avatar/54c63feee66c9753cd59725f00e6c895?s=420&amp;d=https://a248.e.akamai.net/assets.github.com%2Fimages%2Fgravatars%2Fgravatar-user-420.png"/>
    <meta property="og:site_name" content="GitHub"/>
    <meta property="og:description" content="Contribute to scenario-editor development by creating an account on GitHub."/>
    <meta property="twitter:card" content="summary"/>
    <meta property="twitter:site" content="@GitHub">
    <meta property="twitter:title" content="calpath/scenario-editor"/>

    <meta name="description" content="Contribute to scenario-editor development by creating an account on GitHub." />


    <meta content="1490637" name="octolytics-dimension-user_id" /><meta content="3443372" name="octolytics-dimension-repository_id" />
  <link href="https://github.com/calpath/scenario-editor/commits/crud.atom" rel="alternate" title="Recent Commits to scenario-editor:crud" type="application/atom+xml" />

  </head>


  <body class="logged_in page-blob macintosh vis-public env-production  ">
    <div id="wrapper">

      

      
      
      

      <div class="header header-logged-in true">
  <div class="container clearfix">

    <a class="header-logo-invertocat" href="https://github.com/">
  <span class="mega-octicon octicon-mark-github"></span>
</a>

    <div class="divider-vertical"></div>

    
  <a href="/notifications" class="notification-indicator tooltipped downwards" title="You have unread notifications">
    <span class="mail-status unread"></span>
  </a>
  <div class="divider-vertical"></div>


      <div class="command-bar js-command-bar  in-repository">
          <form accept-charset="UTF-8" action="/search" class="command-bar-form" id="top_search_form" method="get">
  <a href="/search/advanced" class="advanced-search-icon tooltipped downwards command-bar-search" id="advanced_search" title="Advanced search"><span class="octicon octicon-gear "></span></a>

  <input type="text" data-hotkey="/ s" name="q" id="js-command-bar-field" placeholder="Search or type a command" tabindex="1" autocapitalize="off"
    data-username="sean-morris"
      data-repo="calpath/scenario-editor"
      data-branch="crud"
      data-sha="81b864442d330c5304b1f9132151542c643378e0"
  >

    <input type="hidden" name="nwo" value="calpath/scenario-editor" />

    <div class="select-menu js-menu-container js-select-menu search-context-select-menu">
      <span class="minibutton select-menu-button js-menu-target">
        <span class="js-select-button">This repository</span>
      </span>

      <div class="select-menu-modal-holder js-menu-content js-navigation-container">
        <div class="select-menu-modal">

          <div class="select-menu-item js-navigation-item selected">
            <span class="select-menu-item-icon octicon octicon-check"></span>
            <input type="radio" class="js-search-this-repository" name="search_target" value="repository" checked="checked" />
            <div class="select-menu-item-text js-select-button-text">This repository</div>
          </div> <!-- /.select-menu-item -->

          <div class="select-menu-item js-navigation-item">
            <span class="select-menu-item-icon octicon octicon-check"></span>
            <input type="radio" name="search_target" value="global" />
            <div class="select-menu-item-text js-select-button-text">All repositories</div>
          </div> <!-- /.select-menu-item -->

        </div>
      </div>
    </div>

  <span class="octicon help tooltipped downwards" title="Show command bar help">
    <span class="octicon octicon-question"></span>
  </span>


  <input type="hidden" name="ref" value="cmdform">

  <div class="divider-vertical"></div>

</form>
        <ul class="top-nav">
            <li class="explore"><a href="https://github.com/explore">Explore</a></li>
            <li><a href="https://gist.github.com">Gist</a></li>
            <li><a href="/blog">Blog</a></li>
          <li><a href="http://help.github.com">Help</a></li>
        </ul>
      </div>

    

  

    <ul id="user-links">
      <li>
        <a href="https://github.com/sean-morris" class="name">
          <img height="20" src="https://secure.gravatar.com/avatar/97c644885762d71c65a21abfc0e2334e?s=140&amp;d=https://a248.e.akamai.net/assets.github.com%2Fimages%2Fgravatars%2Fgravatar-user-420.png" width="20" /> sean-morris
        </a>
      </li>

        <li>
          <a href="/new" id="new_repo" class="tooltipped downwards" title="Create a new repo">
            <span class="octicon octicon-repo-create"></span>
          </a>
        </li>

        <li>
          <a href="/settings/profile" id="account_settings"
            class="tooltipped downwards"
            title="Account settings ">
            <span class="octicon octicon-tools"></span>
          </a>
        </li>
        <li>
          <a class="tooltipped downwards" href="/logout" data-method="post" id="logout" title="Sign out">
            <span class="octicon octicon-log-out"></span>
          </a>
        </li>

    </ul>


<div class="js-new-dropdown-contents hidden">
  <ul class="dropdown-menu">
    <li>
      <a href="/new"><span class="octicon octicon-repo-create"></span> New repository</a>
    </li>
    <li>
        <a href="https://github.com/calpath/scenario-editor/issues/new"><span class="octicon octicon-issue-opened"></span> New issue</a>
    </li>
    <li>
    </li>
    <li>
      <a href="/organizations/new"><span class="octicon octicon-list-unordered"></span> New organization</a>
    </li>
  </ul>
</div>


    
  </div>
</div>

      

      

      


            <div class="site hfeed" itemscope itemtype="http://schema.org/WebPage">
      <div class="hentry">
        
        <div class="pagehead repohead instapaper_ignore readability-menu ">
          <div class="container">
            <div class="title-actions-bar">
              

<ul class="pagehead-actions">

    <li class="nspr">
      <a href="/calpath/scenario-editor/pull/new/crud" class="button minibutton btn-pull-request" icon_class="octicon-git-pull-request"><span class="octicon octicon-git-pull-request"></span>Pull Request</a>
    </li>

    <li class="subscription">
      <form accept-charset="UTF-8" action="/notifications/subscribe" data-autosubmit="true" data-remote="true" method="post"><div style="margin:0;padding:0;display:inline"><input name="authenticity_token" type="hidden" value="mApFup2hp+yxBzATrsfKUeKx0KQy32Q8gJJ3JHoZU+U=" /></div>  <input id="repository_id" name="repository_id" type="hidden" value="3443372" />

    <div class="select-menu js-menu-container js-select-menu">
      <span class="minibutton select-menu-button js-menu-target">
        <span class="js-select-button">
          <span class="octicon octicon-eye-unwatch"></span>
          Unwatch
        </span>
      </span>

      <div class="select-menu-modal-holder js-menu-content">
        <div class="select-menu-modal">
          <div class="select-menu-header">
            <span class="select-menu-title">Notification status</span>
            <span class="octicon octicon-remove-close js-menu-close"></span>
          </div> <!-- /.select-menu-header -->

          <div class="select-menu-list js-navigation-container">

            <div class="select-menu-item js-navigation-item ">
              <span class="select-menu-item-icon octicon octicon-check"></span>
              <div class="select-menu-item-text">
                <input id="do_included" name="do" type="radio" value="included" />
                <h4>Not watching</h4>
                <span class="description">You only receive notifications for discussions in which you participate or are @mentioned.</span>
                <span class="js-select-button-text hidden-select-button-text">
                  <span class="octicon octicon-eye-watch"></span>
                  Watch
                </span>
              </div>
            </div> <!-- /.select-menu-item -->

            <div class="select-menu-item js-navigation-item selected">
              <span class="select-menu-item-icon octicon octicon octicon-check"></span>
              <div class="select-menu-item-text">
                <input checked="checked" id="do_subscribed" name="do" type="radio" value="subscribed" />
                <h4>Watching</h4>
                <span class="description">You receive notifications for all discussions in this repository.</span>
                <span class="js-select-button-text hidden-select-button-text">
                  <span class="octicon octicon-eye-unwatch"></span>
                  Unwatch
                </span>
              </div>
            </div> <!-- /.select-menu-item -->

            <div class="select-menu-item js-navigation-item ">
              <span class="select-menu-item-icon octicon octicon-check"></span>
              <div class="select-menu-item-text">
                <input id="do_ignore" name="do" type="radio" value="ignore" />
                <h4>Ignoring</h4>
                <span class="description">You do not receive any notifications for discussions in this repository.</span>
                <span class="js-select-button-text hidden-select-button-text">
                  <span class="octicon octicon-mute"></span>
                  Stop ignoring
                </span>
              </div>
            </div> <!-- /.select-menu-item -->

          </div> <!-- /.select-menu-list -->

        </div> <!-- /.select-menu-modal -->
      </div> <!-- /.select-menu-modal-holder -->
    </div> <!-- /.select-menu -->

</form>
    </li>

    <li class="js-toggler-container js-social-container starring-container ">
      <a href="/calpath/scenario-editor/unstar" class="minibutton js-toggler-target star-button starred upwards" title="Unstar this repo" data-remote="true" data-method="post" rel="nofollow">
        <span class="octicon octicon-star-delete"></span>
        <span class="text">Unstar</span>
      </a>
      <a href="/calpath/scenario-editor/star" class="minibutton js-toggler-target star-button unstarred upwards" title="Star this repo" data-remote="true" data-method="post" rel="nofollow">
        <span class="octicon octicon-star"></span>
        <span class="text">Star</span>
      </a>
      <a class="social-count js-social-count" href="/calpath/scenario-editor/stargazers">3</a>
    </li>

        <li>
          <a href="/calpath/scenario-editor/fork" class="minibutton js-toggler-target fork-button lighter upwards" title="Fork this repo" rel="facebox nofollow">
            <span class="octicon octicon-git-branch-create"></span>
            <span class="text">Fork</span>
          </a>
          <a href="/calpath/scenario-editor/network" class="social-count">3</a>
        </li>


</ul>

              <h1 itemscope itemtype="http://data-vocabulary.org/Breadcrumb" class="entry-title public">
                <span class="repo-label"><span>public</span></span>
                <span class="mega-octicon octicon-repo"></span>
                <span class="author vcard">
                  <a href="/calpath" class="url fn" itemprop="url" rel="author">
                  <span itemprop="title">calpath</span>
                  </a></span> /
                <strong><a href="/calpath/scenario-editor" class="js-current-repository">scenario-editor</a></strong>
              </h1>
            </div>

            
  <ul class="tabs">
    <li class="pulse-nav"><a href="/calpath/scenario-editor/pulse" class="js-selected-navigation-item " data-selected-links="pulse /calpath/scenario-editor/pulse" rel="nofollow"><span class="octicon octicon-pulse"></span></a></li>
    <li><a href="/calpath/scenario-editor/tree/crud" class="js-selected-navigation-item selected" data-selected-links="repo_source repo_downloads repo_commits repo_tags repo_branches /calpath/scenario-editor/tree/crud">Code</a></li>
    <li><a href="/calpath/scenario-editor/network" class="js-selected-navigation-item " data-selected-links="repo_network /calpath/scenario-editor/network">Network</a></li>
    <li><a href="/calpath/scenario-editor/pulls" class="js-selected-navigation-item " data-selected-links="repo_pulls /calpath/scenario-editor/pulls">Pull Requests <span class='counter'>0</span></a></li>

      <li><a href="/calpath/scenario-editor/issues" class="js-selected-navigation-item " data-selected-links="repo_issues /calpath/scenario-editor/issues">Issues <span class='counter'>11</span></a></li>

      <li><a href="/calpath/scenario-editor/wiki" class="js-selected-navigation-item " data-selected-links="repo_wiki /calpath/scenario-editor/wiki">Wiki</a></li>


    <li><a href="/calpath/scenario-editor/graphs" class="js-selected-navigation-item " data-selected-links="repo_graphs repo_contributors /calpath/scenario-editor/graphs">Graphs</a></li>


  </ul>
  
<div class="tabnav">

  <span class="tabnav-right">
    <ul class="tabnav-tabs">
          <li><a href="/calpath/scenario-editor/tags" class="js-selected-navigation-item tabnav-tab" data-selected-links="repo_tags /calpath/scenario-editor/tags">Tags <span class="counter blank">0</span></a></li>
    </ul>
  </span>

  <div class="tabnav-widget scope">


    <div class="select-menu js-menu-container js-select-menu js-branch-menu">
      <a class="minibutton select-menu-button js-menu-target" data-hotkey="w" data-ref="crud">
        <span class="octicon octicon-branch"></span>
        <i>branch:</i>
        <span class="js-select-button">crud</span>
      </a>

      <div class="select-menu-modal-holder js-menu-content js-navigation-container">

        <div class="select-menu-modal">
          <div class="select-menu-header">
            <span class="select-menu-title">Switch branches/tags</span>
            <span class="octicon octicon-remove-close js-menu-close"></span>
          </div> <!-- /.select-menu-header -->

          <div class="select-menu-filters">
            <div class="select-menu-text-filter">
              <input type="text" id="commitish-filter-field" class="js-filterable-field js-navigation-enable" placeholder="Find or create a branch…">
            </div>
            <div class="select-menu-tabs">
              <ul>
                <li class="select-menu-tab">
                  <a href="#" data-tab-filter="branches" class="js-select-menu-tab">Branches</a>
                </li>
                <li class="select-menu-tab">
                  <a href="#" data-tab-filter="tags" class="js-select-menu-tab">Tags</a>
                </li>
              </ul>
            </div><!-- /.select-menu-tabs -->
          </div><!-- /.select-menu-filters -->

          <div class="select-menu-list select-menu-tab-bucket js-select-menu-tab-bucket css-truncate" data-tab-filter="branches">

            <div data-filterable-for="commitish-filter-field" data-filterable-type="substring">

                <div class="select-menu-item js-navigation-item ">
                  <span class="select-menu-item-icon octicon octicon-check"></span>
                  <a href="/calpath/scenario-editor/blob/add_controllers/src/main/webapp/lib/models/SplitratioProfile.coffee" class="js-navigation-open select-menu-item-text js-select-button-text css-truncate-target" data-name="add_controllers" rel="nofollow" title="add_controllers">add_controllers</a>
                </div> <!-- /.select-menu-item -->
                <div class="select-menu-item js-navigation-item ">
                  <span class="select-menu-item-icon octicon octicon-check"></span>
                  <a href="/calpath/scenario-editor/blob/add_sensors/src/main/webapp/lib/models/SplitratioProfile.coffee" class="js-navigation-open select-menu-item-text js-select-button-text css-truncate-target" data-name="add_sensors" rel="nofollow" title="add_sensors">add_sensors</a>
                </div> <!-- /.select-menu-item -->
                <div class="select-menu-item js-navigation-item ">
                  <span class="select-menu-item-icon octicon octicon-check"></span>
                  <a href="/calpath/scenario-editor/blob/beats_int/src/main/webapp/lib/models/SplitratioProfile.coffee" class="js-navigation-open select-menu-item-text js-select-button-text css-truncate-target" data-name="beats_int" rel="nofollow" title="beats_int">beats_int</a>
                </div> <!-- /.select-menu-item -->
                <div class="select-menu-item js-navigation-item ">
                  <span class="select-menu-item-icon octicon octicon-check"></span>
                  <a href="/calpath/scenario-editor/blob/controller/src/main/webapp/lib/models/SplitratioProfile.coffee" class="js-navigation-open select-menu-item-text js-select-button-text css-truncate-target" data-name="controller" rel="nofollow" title="controller">controller</a>
                </div> <!-- /.select-menu-item -->
                <div class="select-menu-item js-navigation-item selected">
                  <span class="select-menu-item-icon octicon octicon-check"></span>
                  <a href="/calpath/scenario-editor/blob/crud/src/main/webapp/lib/models/SplitratioProfile.coffee" class="js-navigation-open select-menu-item-text js-select-button-text css-truncate-target" data-name="crud" rel="nofollow" title="crud">crud</a>
                </div> <!-- /.select-menu-item -->
                <div class="select-menu-item js-navigation-item ">
                  <span class="select-menu-item-icon octicon octicon-check"></span>
                  <a href="/calpath/scenario-editor/blob/db/src/main/webapp/lib/models/SplitratioProfile.coffee" class="js-navigation-open select-menu-item-text js-select-button-text css-truncate-target" data-name="db" rel="nofollow" title="db">db</a>
                </div> <!-- /.select-menu-item -->
                <div class="select-menu-item js-navigation-item ">
                  <span class="select-menu-item-icon octicon octicon-check"></span>
                  <a href="/calpath/scenario-editor/blob/defaults/src/main/webapp/lib/models/SplitratioProfile.coffee" class="js-navigation-open select-menu-item-text js-select-button-text css-truncate-target" data-name="defaults" rel="nofollow" title="defaults">defaults</a>
                </div> <!-- /.select-menu-item -->
                <div class="select-menu-item js-navigation-item ">
                  <span class="select-menu-item-icon octicon octicon-check"></span>
                  <a href="/calpath/scenario-editor/blob/dev/src/main/webapp/lib/models/SplitratioProfile.coffee" class="js-navigation-open select-menu-item-text js-select-button-text css-truncate-target" data-name="dev" rel="nofollow" title="dev">dev</a>
                </div> <!-- /.select-menu-item -->
                <div class="select-menu-item js-navigation-item ">
                  <span class="select-menu-item-icon octicon octicon-check"></span>
                  <a href="/calpath/scenario-editor/blob/events/src/main/webapp/lib/models/SplitratioProfile.coffee" class="js-navigation-open select-menu-item-text js-select-button-text css-truncate-target" data-name="events" rel="nofollow" title="events">events</a>
                </div> <!-- /.select-menu-item -->
                <div class="select-menu-item js-navigation-item ">
                  <span class="select-menu-item-icon octicon octicon-check"></span>
                  <a href="/calpath/scenario-editor/blob/master/src/main/webapp/lib/models/SplitratioProfile.coffee" class="js-navigation-open select-menu-item-text js-select-button-text css-truncate-target" data-name="master" rel="nofollow" title="master">master</a>
                </div> <!-- /.select-menu-item -->
                <div class="select-menu-item js-navigation-item ">
                  <span class="select-menu-item-icon octicon octicon-check"></span>
                  <a href="/calpath/scenario-editor/blob/network_mode/src/main/webapp/lib/models/SplitratioProfile.coffee" class="js-navigation-open select-menu-item-text js-select-button-text css-truncate-target" data-name="network_mode" rel="nofollow" title="network_mode">network_mode</a>
                </div> <!-- /.select-menu-item -->
                <div class="select-menu-item js-navigation-item ">
                  <span class="select-menu-item-icon octicon octicon-check"></span>
                  <a href="/calpath/scenario-editor/blob/nodes/src/main/webapp/lib/models/SplitratioProfile.coffee" class="js-navigation-open select-menu-item-text js-select-button-text css-truncate-target" data-name="nodes" rel="nofollow" title="nodes">nodes</a>
                </div> <!-- /.select-menu-item -->
                <div class="select-menu-item js-navigation-item ">
                  <span class="select-menu-item-icon octicon octicon-check"></span>
                  <a href="/calpath/scenario-editor/blob/parallel_links/src/main/webapp/lib/models/SplitratioProfile.coffee" class="js-navigation-open select-menu-item-text js-select-button-text css-truncate-target" data-name="parallel_links" rel="nofollow" title="parallel_links">parallel_links</a>
                </div> <!-- /.select-menu-item -->
                <div class="select-menu-item js-navigation-item ">
                  <span class="select-menu-item-icon octicon octicon-check"></span>
                  <a href="/calpath/scenario-editor/blob/restructure_classes/src/main/webapp/lib/models/SplitratioProfile.coffee" class="js-navigation-open select-menu-item-text js-select-button-text css-truncate-target" data-name="restructure_classes" rel="nofollow" title="restructure_classes">restructure_classes</a>
                </div> <!-- /.select-menu-item -->
                <div class="select-menu-item js-navigation-item ">
                  <span class="select-menu-item-icon octicon octicon-check"></span>
                  <a href="/calpath/scenario-editor/blob/visualize_demand/src/main/webapp/lib/models/SplitratioProfile.coffee" class="js-navigation-open select-menu-item-text js-select-button-text css-truncate-target" data-name="visualize_demand" rel="nofollow" title="visualize_demand">visualize_demand</a>
                </div> <!-- /.select-menu-item -->
            </div>

              <form accept-charset="UTF-8" action="/calpath/scenario-editor/branches" class="js-create-branch select-menu-item select-menu-new-item-form js-navigation-item js-new-item-form" method="post"><div style="margin:0;padding:0;display:inline"><input name="authenticity_token" type="hidden" value="mApFup2hp+yxBzATrsfKUeKx0KQy32Q8gJJ3JHoZU+U=" /></div>

                <span class="octicon octicon-git-branch-create select-menu-item-icon"></span>
                <div class="select-menu-item-text">
                  <h4>Create branch: <span class="js-new-item-name"></span></h4>
                  <span class="description">from ‘crud’</span>
                </div>
                <input type="hidden" name="name" id="name" class="js-new-item-value">
                <input type="hidden" name="branch" id="branch" value="crud" />
                <input type="hidden" name="path" id="branch" value="src/main/webapp/lib/models/SplitratioProfile.coffee" />
              </form> <!-- /.select-menu-item -->

          </div> <!-- /.select-menu-list -->


          <div class="select-menu-list select-menu-tab-bucket js-select-menu-tab-bucket css-truncate" data-tab-filter="tags">
            <div data-filterable-for="commitish-filter-field" data-filterable-type="substring">

            </div>

            <div class="select-menu-no-results">Nothing to show</div>

          </div> <!-- /.select-menu-list -->

        </div> <!-- /.select-menu-modal -->
      </div> <!-- /.select-menu-modal-holder -->
    </div> <!-- /.select-menu -->

  </div> <!-- /.scope -->

  <ul class="tabnav-tabs">
    <li><a href="/calpath/scenario-editor/tree/crud" class="selected js-selected-navigation-item tabnav-tab" data-selected-links="repo_source /calpath/scenario-editor/tree/crud">Files</a></li>
    <li><a href="/calpath/scenario-editor/commits/crud" class="js-selected-navigation-item tabnav-tab" data-selected-links="repo_commits /calpath/scenario-editor/commits/crud">Commits</a></li>
    <li><a href="/calpath/scenario-editor/branches" class="js-selected-navigation-item tabnav-tab" data-selected-links="repo_branches /calpath/scenario-editor/branches" rel="nofollow">Branches <span class="counter ">15</span></a></li>
  </ul>

</div>

  
  
  


            
          </div>
        </div><!-- /.repohead -->

        <div id="js-repo-pjax-container" class="container context-loader-container" data-pjax-container>
          


<!-- blob contrib key: blob_contributors:v21:0c34b0ceb66ffb99fdf2a1bbce48b920 -->
<!-- blob contrib frag key: views10/v8/blob_contributors:v21:0c34b0ceb66ffb99fdf2a1bbce48b920 -->


<div id="slider">
    <div class="frame-meta">

      <p title="This is a placeholder element" class="js-history-link-replace hidden"></p>

        <div class="breadcrumb">
          <span class='bold'><span itemscope="" itemtype="http://data-vocabulary.org/Breadcrumb"><a href="/calpath/scenario-editor/tree/crud" class="js-slide-to" data-branch="crud" data-direction="back" itemscope="url"><span itemprop="title">scenario-editor</span></a></span></span><span class="separator"> / </span><span itemscope="" itemtype="http://data-vocabulary.org/Breadcrumb"><a href="/calpath/scenario-editor/tree/crud/src" class="js-slide-to" data-branch="crud" data-direction="back" itemscope="url"><span itemprop="title">src</span></a></span><span class="separator"> / </span><span itemscope="" itemtype="http://data-vocabulary.org/Breadcrumb"><a href="/calpath/scenario-editor/tree/crud/src/main" class="js-slide-to" data-branch="crud" data-direction="back" itemscope="url"><span itemprop="title">main</span></a></span><span class="separator"> / </span><span itemscope="" itemtype="http://data-vocabulary.org/Breadcrumb"><a href="/calpath/scenario-editor/tree/crud/src/main/webapp" class="js-slide-to" data-branch="crud" data-direction="back" itemscope="url"><span itemprop="title">webapp</span></a></span><span class="separator"> / </span><span itemscope="" itemtype="http://data-vocabulary.org/Breadcrumb"><a href="/calpath/scenario-editor/tree/crud/src/main/webapp/lib" class="js-slide-to" data-branch="crud" data-direction="back" itemscope="url"><span itemprop="title">lib</span></a></span><span class="separator"> / </span><span itemscope="" itemtype="http://data-vocabulary.org/Breadcrumb"><a href="/calpath/scenario-editor/tree/crud/src/main/webapp/lib/models" class="js-slide-to" data-branch="crud" data-direction="back" itemscope="url"><span itemprop="title">models</span></a></span><span class="separator"> / </span><strong class="final-path">SplitratioProfile.coffee</strong> <span class="js-zeroclipboard zeroclipboard-button" data-clipboard-text="src/main/webapp/lib/models/SplitratioProfile.coffee" data-copied-hint="copied!" title="copy to clipboard"><span class="octicon octicon-clippy"></span></span>
        </div>

      <a href="/calpath/scenario-editor/find/crud" class="js-slide-to" data-hotkey="t" style="display:none">Show File Finder</a>


        
  <div class="commit file-history-tease">
    <img class="main-avatar" height="24" src="https://secure.gravatar.com/avatar/97c644885762d71c65a21abfc0e2334e?s=140&amp;d=https://a248.e.akamai.net/assets.github.com%2Fimages%2Fgravatars%2Fgravatar-user-420.png" width="24" />
    <span class="author"><a href="/sean-morris" rel="author">sean-morris</a></span>
    <time class="js-relative-date" datetime="2013-05-10T15:16:58-07:00" title="2013-05-10 15:16:58">May 10, 2013</time>
    <div class="commit-title">
        <a href="/calpath/scenario-editor/commit/b5827fa96bc4d720cc9a58263052d01744280538" class="message">conformed to MO xsd: loading simple network. More testing needed</a>
    </div>

    <div class="participation">
      <p class="quickstat"><a href="#blob_contributors_box" rel="facebox"><strong>2</strong> contributors</a></p>
          <a class="avatar tooltipped downwards" title="sean-morris" href="/calpath/scenario-editor/commits/crud/src/main/webapp/lib/models/SplitratioProfile.coffee?author=sean-morris"><img height="20" src="https://secure.gravatar.com/avatar/97c644885762d71c65a21abfc0e2334e?s=140&amp;d=https://a248.e.akamai.net/assets.github.com%2Fimages%2Fgravatars%2Fgravatar-user-420.png" width="20" /></a>
    <a class="avatar tooltipped downwards" title="mnjuhn" href="/calpath/scenario-editor/commits/crud/src/main/webapp/lib/models/SplitratioProfile.coffee?author=mnjuhn"><img height="20" src="https://secure.gravatar.com/avatar/a827c01b8cb044495f022ea202c6ee6e?s=140&amp;d=https://a248.e.akamai.net/assets.github.com%2Fimages%2Fgravatars%2Fgravatar-user-420.png" width="20" /></a>


    </div>
    <div id="blob_contributors_box" style="display:none">
      <h2>Users on GitHub who have contributed to this file</h2>
      <ul class="facebox-user-list">
        <li>
          <img height="24" src="https://secure.gravatar.com/avatar/97c644885762d71c65a21abfc0e2334e?s=140&amp;d=https://a248.e.akamai.net/assets.github.com%2Fimages%2Fgravatars%2Fgravatar-user-420.png" width="24" />
          <a href="/sean-morris">sean-morris</a>
        </li>
        <li>
          <img height="24" src="https://secure.gravatar.com/avatar/a827c01b8cb044495f022ea202c6ee6e?s=140&amp;d=https://a248.e.akamai.net/assets.github.com%2Fimages%2Fgravatars%2Fgravatar-user-420.png" width="24" />
          <a href="/mnjuhn">mnjuhn</a>
        </li>
      </ul>
    </div>
  </div>


    </div><!-- ./.frame-meta -->

    <div class="frames">
      <div class="frame" data-permalink-url="/calpath/scenario-editor/blob/8a03f820ffe93a029e33d87831aa3a5e3b1d8628/src/main/webapp/lib/models/SplitratioProfile.coffee" data-title="scenario-editor/src/main/webapp/lib/models/SplitratioProfile.coffee at crud · calpath/scenario-editor · GitHub" data-type="blob">

        <div id="files" class="bubble">
          <div class="file">
            <div class="meta">
              <div class="info">
                <span class="icon"><b class="octicon octicon-file-text"></b></span>
                <span class="mode" title="File Mode">file</span>
                  <span>52 lines (49 sloc)</span>
                <span>2.354 kb</span>
              </div>
              <div class="actions">
                <div class="button-group">
                        <a class="minibutton"
                           href="/calpath/scenario-editor/edit/crud/src/main/webapp/lib/models/SplitratioProfile.coffee"
                           data-method="post" rel="nofollow" data-hotkey="e">Edit</a>
                  <a href="/calpath/scenario-editor/raw/crud/src/main/webapp/lib/models/SplitratioProfile.coffee" class="button minibutton " id="raw-url">Raw</a>
                    <a href="/calpath/scenario-editor/blame/crud/src/main/webapp/lib/models/SplitratioProfile.coffee" class="button minibutton ">Blame</a>
                  <a href="/calpath/scenario-editor/commits/crud/src/main/webapp/lib/models/SplitratioProfile.coffee" class="button minibutton " rel="nofollow">History</a>
                </div><!-- /.button-group -->
              </div><!-- /.actions -->

            </div>
                <div class="blob-wrapper data type-coffeescript js-blob-data">
      <table class="file-code file-diff">
        <tr class="file-code-line">
          <td class="blob-line-nums">
            <span id="L1" rel="#L1">1</span>
<span id="L2" rel="#L2">2</span>
<span id="L3" rel="#L3">3</span>
<span id="L4" rel="#L4">4</span>
<span id="L5" rel="#L5">5</span>
<span id="L6" rel="#L6">6</span>
<span id="L7" rel="#L7">7</span>
<span id="L8" rel="#L8">8</span>
<span id="L9" rel="#L9">9</span>
<span id="L10" rel="#L10">10</span>
<span id="L11" rel="#L11">11</span>
<span id="L12" rel="#L12">12</span>
<span id="L13" rel="#L13">13</span>
<span id="L14" rel="#L14">14</span>
<span id="L15" rel="#L15">15</span>
<span id="L16" rel="#L16">16</span>
<span id="L17" rel="#L17">17</span>
<span id="L18" rel="#L18">18</span>
<span id="L19" rel="#L19">19</span>
<span id="L20" rel="#L20">20</span>
<span id="L21" rel="#L21">21</span>
<span id="L22" rel="#L22">22</span>
<span id="L23" rel="#L23">23</span>
<span id="L24" rel="#L24">24</span>
<span id="L25" rel="#L25">25</span>
<span id="L26" rel="#L26">26</span>
<span id="L27" rel="#L27">27</span>
<span id="L28" rel="#L28">28</span>
<span id="L29" rel="#L29">29</span>
<span id="L30" rel="#L30">30</span>
<span id="L31" rel="#L31">31</span>
<span id="L32" rel="#L32">32</span>
<span id="L33" rel="#L33">33</span>
<span id="L34" rel="#L34">34</span>
<span id="L35" rel="#L35">35</span>
<span id="L36" rel="#L36">36</span>
<span id="L37" rel="#L37">37</span>
<span id="L38" rel="#L38">38</span>
<span id="L39" rel="#L39">39</span>
<span id="L40" rel="#L40">40</span>
<span id="L41" rel="#L41">41</span>
<span id="L42" rel="#L42">42</span>
<span id="L43" rel="#L43">43</span>
<span id="L44" rel="#L44">44</span>
<span id="L45" rel="#L45">45</span>
<span id="L46" rel="#L46">46</span>
<span id="L47" rel="#L47">47</span>
<span id="L48" rel="#L48">48</span>
<span id="L49" rel="#L49">49</span>
<span id="L50" rel="#L50">50</span>
<span id="L51" rel="#L51">51</span>
<span id="L52" rel="#L52">52</span>

          </td>
          <td class="blob-line-code">
                  <div class="highlight"><pre><div class='line' id='LC1'><span class="k">class</span> <span class="nb">window</span><span class="p">.</span><span class="nx">beats</span><span class="p">.</span><span class="nx">SplitRatioProfile</span> <span class="k">extends</span> <span class="nx">Backbone</span><span class="p">.</span><span class="nx">Model</span></div><div class='line' id='LC2'>&nbsp;&nbsp;<span class="cm">### $a = alias for beats namespace ###</span></div><div class='line' id='LC3'>&nbsp;&nbsp;<span class="nv">$a = </span><span class="nb">window</span><span class="p">.</span><span class="nx">beats</span></div><div class='line' id='LC4'>&nbsp;&nbsp;<span class="vi">@from_xml1: </span><span class="nf">(xml, object_with_id) -&gt;</span></div><div class='line' id='LC5'>&nbsp;&nbsp;&nbsp;&nbsp;<span class="nv">deferred = </span><span class="p">[]</span></div><div class='line' id='LC6'>&nbsp;&nbsp;&nbsp;&nbsp;<span class="nv">obj = </span><span class="nx">@from_xml2</span><span class="p">(</span><span class="nx">xml</span><span class="p">,</span> <span class="nx">deferred</span><span class="p">,</span> <span class="nx">object_with_id</span><span class="p">)</span></div><div class='line' id='LC7'>&nbsp;&nbsp;&nbsp;&nbsp;<span class="nx">fn</span><span class="p">()</span> <span class="k">for</span> <span class="nx">fn</span> <span class="k">in</span> <span class="nx">deferred</span></div><div class='line' id='LC8'>&nbsp;&nbsp;&nbsp;&nbsp;<span class="nx">obj</span></div><div class='line' id='LC9'>&nbsp;&nbsp;</div><div class='line' id='LC10'>&nbsp;&nbsp;<span class="vi">@from_xml2: </span><span class="nf">(xml, deferred, object_with_id) -&gt;</span></div><div class='line' id='LC11'>&nbsp;&nbsp;&nbsp;&nbsp;<span class="k">return</span> <span class="kc">null</span> <span class="k">if</span> <span class="p">(</span><span class="o">not</span> <span class="nx">xml</span><span class="o">?</span> <span class="o">or</span> <span class="nx">xml</span><span class="p">.</span><span class="nx">length</span> <span class="o">==</span> <span class="mi">0</span><span class="p">)</span></div><div class='line' id='LC12'>&nbsp;&nbsp;&nbsp;&nbsp;<span class="nv">obj = </span><span class="k">new</span> <span class="nb">window</span><span class="p">.</span><span class="nx">beats</span><span class="p">.</span><span class="nx">SplitRatioProfile</span><span class="p">()</span></div><div class='line' id='LC13'>&nbsp;&nbsp;&nbsp;&nbsp;<span class="nv">splitratio = </span><span class="nx">xml</span><span class="p">.</span><span class="nx">children</span><span class="p">(</span><span class="s">&#39;splitratio&#39;</span><span class="p">)</span></div><div class='line' id='LC14'>&nbsp;&nbsp;&nbsp;&nbsp;<span class="nx">obj</span><span class="p">.</span><span class="nx">set</span><span class="p">(</span><span class="s">&#39;splitratio&#39;</span><span class="p">,</span> <span class="nx">_</span><span class="p">.</span><span class="nx">map</span><span class="p">(</span><span class="nx">$</span><span class="p">(</span><span class="nx">splitratio</span><span class="p">),</span> <span class="nf">(splitratio_i) -&gt;</span> <span class="nx">$a</span><span class="p">.</span><span class="nx">Splitratio</span><span class="p">.</span><span class="nx">from_xml2</span><span class="p">(</span><span class="nx">$</span><span class="p">(</span><span class="nx">splitratio_i</span><span class="p">),</span> <span class="nx">deferred</span><span class="p">,</span> <span class="nx">object_with_id</span><span class="p">)))</span></div><div class='line' id='LC15'>&nbsp;&nbsp;&nbsp;&nbsp;<span class="nv">crudFlag = </span><span class="nx">$</span><span class="p">(</span><span class="nx">xml</span><span class="p">).</span><span class="nx">attr</span><span class="p">(</span><span class="s">&#39;crudFlag&#39;</span><span class="p">)</span></div><div class='line' id='LC16'>&nbsp;&nbsp;&nbsp;&nbsp;<span class="nx">obj</span><span class="p">.</span><span class="nx">set</span><span class="p">(</span><span class="s">&#39;crudFlag&#39;</span><span class="p">,</span> <span class="nx">crudFlag</span><span class="p">)</span></div><div class='line' id='LC17'>&nbsp;&nbsp;&nbsp;&nbsp;<span class="nv">id = </span><span class="nx">$</span><span class="p">(</span><span class="nx">xml</span><span class="p">).</span><span class="nx">attr</span><span class="p">(</span><span class="s">&#39;id&#39;</span><span class="p">)</span></div><div class='line' id='LC18'>&nbsp;&nbsp;&nbsp;&nbsp;<span class="nx">obj</span><span class="p">.</span><span class="nx">set</span><span class="p">(</span><span class="s">&#39;id&#39;</span><span class="p">,</span> <span class="nb">Number</span><span class="p">(</span><span class="nx">id</span><span class="p">))</span></div><div class='line' id='LC19'>&nbsp;&nbsp;&nbsp;&nbsp;<span class="nv">node_id = </span><span class="nx">$</span><span class="p">(</span><span class="nx">xml</span><span class="p">).</span><span class="nx">attr</span><span class="p">(</span><span class="s">&#39;node_id&#39;</span><span class="p">)</span></div><div class='line' id='LC20'>&nbsp;&nbsp;&nbsp;&nbsp;<span class="nx">obj</span><span class="p">.</span><span class="nx">set</span><span class="p">(</span><span class="s">&#39;node_id&#39;</span><span class="p">,</span> <span class="nb">Number</span><span class="p">(</span><span class="nx">node_id</span><span class="p">))</span></div><div class='line' id='LC21'>&nbsp;&nbsp;&nbsp;&nbsp;<span class="nv">start_time = </span><span class="nx">$</span><span class="p">(</span><span class="nx">xml</span><span class="p">).</span><span class="nx">attr</span><span class="p">(</span><span class="s">&#39;start_time&#39;</span><span class="p">)</span></div><div class='line' id='LC22'>&nbsp;&nbsp;&nbsp;&nbsp;<span class="nx">obj</span><span class="p">.</span><span class="nx">set</span><span class="p">(</span><span class="s">&#39;start_time&#39;</span><span class="p">,</span> <span class="nb">Number</span><span class="p">(</span><span class="nx">start_time</span><span class="p">))</span></div><div class='line' id='LC23'>&nbsp;&nbsp;&nbsp;&nbsp;<span class="nv">dt = </span><span class="nx">$</span><span class="p">(</span><span class="nx">xml</span><span class="p">).</span><span class="nx">attr</span><span class="p">(</span><span class="s">&#39;dt&#39;</span><span class="p">)</span></div><div class='line' id='LC24'>&nbsp;&nbsp;&nbsp;&nbsp;<span class="nx">obj</span><span class="p">.</span><span class="nx">set</span><span class="p">(</span><span class="s">&#39;dt&#39;</span><span class="p">,</span> <span class="nb">Number</span><span class="p">(</span><span class="nx">dt</span><span class="p">))</span></div><div class='line' id='LC25'>&nbsp;&nbsp;&nbsp;&nbsp;<span class="nv">network_id = </span><span class="nx">$</span><span class="p">(</span><span class="nx">xml</span><span class="p">).</span><span class="nx">attr</span><span class="p">(</span><span class="s">&#39;network_id&#39;</span><span class="p">)</span></div><div class='line' id='LC26'>&nbsp;&nbsp;&nbsp;&nbsp;<span class="nx">obj</span><span class="p">.</span><span class="nx">set</span><span class="p">(</span><span class="s">&#39;network_id&#39;</span><span class="p">,</span> <span class="nb">Number</span><span class="p">(</span><span class="nx">network_id</span><span class="p">))</span></div><div class='line' id='LC27'>&nbsp;&nbsp;&nbsp;&nbsp;<span class="nv">destination_network_id = </span><span class="nx">$</span><span class="p">(</span><span class="nx">xml</span><span class="p">).</span><span class="nx">attr</span><span class="p">(</span><span class="s">&#39;destination_network_id&#39;</span><span class="p">)</span></div><div class='line' id='LC28'>&nbsp;&nbsp;&nbsp;&nbsp;<span class="nx">obj</span><span class="p">.</span><span class="nx">set</span><span class="p">(</span><span class="s">&#39;destination_network_id&#39;</span><span class="p">,</span> <span class="nb">Number</span><span class="p">(</span><span class="nx">destination_network_id</span><span class="p">))</span></div><div class='line' id='LC29'>&nbsp;&nbsp;&nbsp;&nbsp;<span class="nv">mod_stamp = </span><span class="nx">$</span><span class="p">(</span><span class="nx">xml</span><span class="p">).</span><span class="nx">attr</span><span class="p">(</span><span class="s">&#39;mod_stamp&#39;</span><span class="p">)</span></div><div class='line' id='LC30'>&nbsp;&nbsp;&nbsp;&nbsp;<span class="nx">obj</span><span class="p">.</span><span class="nx">set</span><span class="p">(</span><span class="s">&#39;mod_stamp&#39;</span><span class="p">,</span> <span class="nx">mod_stamp</span><span class="p">)</span></div><div class='line' id='LC31'>&nbsp;&nbsp;&nbsp;&nbsp;<span class="k">if</span> <span class="nx">obj</span><span class="p">.</span><span class="nx">resolve_references</span></div><div class='line' id='LC32'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="nx">obj</span><span class="p">.</span><span class="nx">resolve_references</span><span class="p">(</span><span class="nx">deferred</span><span class="p">,</span> <span class="nx">object_with_id</span><span class="p">)</span></div><div class='line' id='LC33'>&nbsp;&nbsp;&nbsp;&nbsp;<span class="nx">obj</span></div><div class='line' id='LC34'>&nbsp;&nbsp;</div><div class='line' id='LC35'>&nbsp;&nbsp;<span class="nv">to_xml: </span><span class="nf">(doc) -&gt;</span></div><div class='line' id='LC36'>&nbsp;&nbsp;&nbsp;&nbsp;<span class="nv">xml = </span><span class="nx">doc</span><span class="p">.</span><span class="nx">createElement</span><span class="p">(</span><span class="s">&#39;splitRatioProfile&#39;</span><span class="p">)</span></div><div class='line' id='LC37'>&nbsp;&nbsp;&nbsp;&nbsp;<span class="k">if</span> <span class="nx">@encode_references</span></div><div class='line' id='LC38'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class="nx">@encode_references</span><span class="p">()</span></div><div class='line' id='LC39'>&nbsp;&nbsp;&nbsp;&nbsp;<span class="nx">_</span><span class="p">.</span><span class="nx">each</span><span class="p">(</span><span class="nx">@get</span><span class="p">(</span><span class="s">&#39;splitratio&#39;</span><span class="p">)</span> <span class="o">||</span> <span class="p">[],</span> <span class="nf">(a_splitratio) -&gt;</span> <span class="nx">xml</span><span class="p">.</span><span class="nx">appendChild</span><span class="p">(</span><span class="nx">a_splitratio</span><span class="p">.</span><span class="nx">to_xml</span><span class="p">(</span><span class="nx">doc</span><span class="p">)))</span></div><div class='line' id='LC40'>&nbsp;&nbsp;&nbsp;&nbsp;<span class="nx">xml</span><span class="p">.</span><span class="nx">setAttribute</span><span class="p">(</span><span class="s">&#39;crudFlag&#39;</span><span class="p">,</span> <span class="nx">@get</span><span class="p">(</span><span class="s">&#39;crudFlag&#39;</span><span class="p">))</span> <span class="k">if</span> <span class="nx">@has</span><span class="p">(</span><span class="s">&#39;crudFlag&#39;</span><span class="p">)</span></div><div class='line' id='LC41'>&nbsp;&nbsp;&nbsp;&nbsp;<span class="nx">xml</span><span class="p">.</span><span class="nx">setAttribute</span><span class="p">(</span><span class="s">&#39;id&#39;</span><span class="p">,</span> <span class="nx">@get</span><span class="p">(</span><span class="s">&#39;id&#39;</span><span class="p">))</span> <span class="k">if</span> <span class="nx">@has</span><span class="p">(</span><span class="s">&#39;id&#39;</span><span class="p">)</span></div><div class='line' id='LC42'>&nbsp;&nbsp;&nbsp;&nbsp;<span class="nx">xml</span><span class="p">.</span><span class="nx">setAttribute</span><span class="p">(</span><span class="s">&#39;node_id&#39;</span><span class="p">,</span> <span class="nx">@get</span><span class="p">(</span><span class="s">&#39;node_id&#39;</span><span class="p">))</span> <span class="k">if</span> <span class="nx">@has</span><span class="p">(</span><span class="s">&#39;node_id&#39;</span><span class="p">)</span></div><div class='line' id='LC43'>&nbsp;&nbsp;&nbsp;&nbsp;<span class="k">if</span> <span class="nx">@has</span><span class="p">(</span><span class="s">&#39;start_time&#39;</span><span class="p">)</span> <span class="o">&amp;&amp;</span> <span class="nx">@start_time</span> <span class="o">!=</span> <span class="mi">0</span> <span class="k">then</span> <span class="nx">xml</span><span class="p">.</span><span class="nx">setAttribute</span><span class="p">(</span><span class="s">&#39;start_time&#39;</span><span class="p">,</span> <span class="nx">@get</span><span class="p">(</span><span class="s">&#39;start_time&#39;</span><span class="p">))</span></div><div class='line' id='LC44'>&nbsp;&nbsp;&nbsp;&nbsp;<span class="nx">xml</span><span class="p">.</span><span class="nx">setAttribute</span><span class="p">(</span><span class="s">&#39;dt&#39;</span><span class="p">,</span> <span class="nx">@get</span><span class="p">(</span><span class="s">&#39;dt&#39;</span><span class="p">))</span> <span class="k">if</span> <span class="nx">@has</span><span class="p">(</span><span class="s">&#39;dt&#39;</span><span class="p">)</span></div><div class='line' id='LC45'>&nbsp;&nbsp;&nbsp;&nbsp;<span class="nx">xml</span><span class="p">.</span><span class="nx">setAttribute</span><span class="p">(</span><span class="s">&#39;network_id&#39;</span><span class="p">,</span> <span class="nx">@get</span><span class="p">(</span><span class="s">&#39;network_id&#39;</span><span class="p">))</span> <span class="k">if</span> <span class="nx">@has</span><span class="p">(</span><span class="s">&#39;network_id&#39;</span><span class="p">)</span></div><div class='line' id='LC46'>&nbsp;&nbsp;&nbsp;&nbsp;<span class="nx">xml</span><span class="p">.</span><span class="nx">setAttribute</span><span class="p">(</span><span class="s">&#39;destination_network_id&#39;</span><span class="p">,</span> <span class="nx">@get</span><span class="p">(</span><span class="s">&#39;destination_network_id&#39;</span><span class="p">))</span> <span class="k">if</span> <span class="nx">@has</span><span class="p">(</span><span class="s">&#39;destination_network_id&#39;</span><span class="p">)</span></div><div class='line' id='LC47'>&nbsp;&nbsp;&nbsp;&nbsp;<span class="k">if</span> <span class="nx">@has</span><span class="p">(</span><span class="s">&#39;mod_stamp&#39;</span><span class="p">)</span> <span class="o">&amp;&amp;</span> <span class="nx">@mod_stamp</span> <span class="o">!=</span> <span class="s">&quot;0&quot;</span> <span class="k">then</span> <span class="nx">xml</span><span class="p">.</span><span class="nx">setAttribute</span><span class="p">(</span><span class="s">&#39;mod_stamp&#39;</span><span class="p">,</span> <span class="nx">@get</span><span class="p">(</span><span class="s">&#39;mod_stamp&#39;</span><span class="p">))</span></div><div class='line' id='LC48'>&nbsp;&nbsp;&nbsp;&nbsp;<span class="nx">xml</span></div><div class='line' id='LC49'>&nbsp;&nbsp;</div><div class='line' id='LC50'>&nbsp;&nbsp;<span class="nv">deep_copy: </span><span class="nf">-&gt;</span> <span class="nx">SplitRatioProfile</span><span class="p">.</span><span class="nx">from_xml1</span><span class="p">(</span><span class="nx">@to_xml</span><span class="p">(),</span> <span class="p">{})</span></div><div class='line' id='LC51'>&nbsp;&nbsp;<span class="nv">inspect: </span><span class="nf">(depth = 1, indent = false, orig_depth = -1) -&gt;</span> <span class="kc">null</span></div><div class='line' id='LC52'>&nbsp;&nbsp;<span class="nv">make_tree: </span><span class="nf">-&gt;</span> <span class="kc">null</span></div></pre></div>
          </td>
        </tr>
      </table>
  </div>

          </div>
        </div>

        <a href="#jump-to-line" rel="facebox" data-hotkey="l" class="js-jump-to-line" style="display:none">Jump to Line</a>
        <div id="jump-to-line" style="display:none">
          <h2>Jump to Line</h2>
          <form accept-charset="UTF-8" class="js-jump-to-line-form">
            <input class="textfield js-jump-to-line-field" type="text">
            <div class="full-button">
              <button type="submit" class="button">Go</button>
            </div>
          </form>
        </div>

      </div>
    </div>
</div>

<div id="js-frame-loading-template" class="frame frame-loading large-loading-area" style="display:none;">
  <img class="js-frame-loading-spinner" src="https://a248.e.akamai.net/assets.github.com/images/spinners/octocat-spinner-128.gif?1359500886" height="64" width="64">
</div>


        </div>
      </div>
      <div class="modal-backdrop"></div>
    </div>

      <div id="footer-push"></div><!-- hack for sticky footer -->
    </div><!-- end of wrapper - hack for sticky footer -->

      <!-- footer -->
      <div id="footer">
  <div class="container clearfix">

      <dl class="footer_nav">
        <dt>GitHub</dt>
        <dd><a href="https://github.com/about">About us</a></dd>
        <dd><a href="https://github.com/blog">Blog</a></dd>
        <dd><a href="https://github.com/contact">Contact &amp; support</a></dd>
        <dd><a href="http://enterprise.github.com/">GitHub Enterprise</a></dd>
        <dd><a href="http://status.github.com/">Site status</a></dd>
      </dl>

      <dl class="footer_nav">
        <dt>Applications</dt>
        <dd><a href="http://mac.github.com/">GitHub for Mac</a></dd>
        <dd><a href="http://windows.github.com/">GitHub for Windows</a></dd>
        <dd><a href="http://eclipse.github.com/">GitHub for Eclipse</a></dd>
        <dd><a href="http://mobile.github.com/">GitHub mobile apps</a></dd>
      </dl>

      <dl class="footer_nav">
        <dt>Services</dt>
        <dd><a href="http://get.gaug.es/">Gauges: Web analytics</a></dd>
        <dd><a href="http://speakerdeck.com">Speaker Deck: Presentations</a></dd>
        <dd><a href="https://gist.github.com">Gist: Code snippets</a></dd>
        <dd><a href="http://jobs.github.com/">Job board</a></dd>
      </dl>

      <dl class="footer_nav">
        <dt>Documentation</dt>
        <dd><a href="http://help.github.com/">GitHub Help</a></dd>
        <dd><a href="http://developer.github.com/">Developer API</a></dd>
        <dd><a href="http://github.github.com/github-flavored-markdown/">GitHub Flavored Markdown</a></dd>
        <dd><a href="http://pages.github.com/">GitHub Pages</a></dd>
      </dl>

      <dl class="footer_nav">
        <dt>More</dt>
        <dd><a href="http://training.github.com/">Training</a></dd>
        <dd><a href="https://github.com/edu">Students &amp; teachers</a></dd>
        <dd><a href="http://shop.github.com">The Shop</a></dd>
        <dd><a href="/plans">Plans &amp; pricing</a></dd>
        <dd><a href="http://octodex.github.com/">The Octodex</a></dd>
      </dl>

      <hr class="footer-divider">


    <p class="right">&copy; 2013 <span title="0.15434s from fe19.rs.github.com">GitHub</span>, Inc. All rights reserved.</p>
    <a class="left" href="https://github.com/">
      <span class="mega-octicon octicon-mark-github"></span>
    </a>
    <ul id="legal">
        <li><a href="https://github.com/site/terms">Terms of Service</a></li>
        <li><a href="https://github.com/site/privacy">Privacy</a></li>
        <li><a href="https://github.com/security">Security</a></li>
    </ul>

  </div><!-- /.container -->

</div><!-- /.#footer -->


    <div class="fullscreen-overlay js-fullscreen-overlay" id="fullscreen_overlay">
  <div class="fullscreen-container js-fullscreen-container">
    <div class="textarea-wrap">
      <textarea name="fullscreen-contents" id="fullscreen-contents" class="js-fullscreen-contents" placeholder="" data-suggester="fullscreen_suggester"></textarea>
          <div class="suggester-container">
              <div class="suggester fullscreen-suggester js-navigation-container" id="fullscreen_suggester"
                 data-url="/calpath/scenario-editor/suggestions/commit">
              </div>
          </div>
    </div>
  </div>
  <div class="fullscreen-sidebar">
    <a href="#" class="exit-fullscreen js-exit-fullscreen tooltipped leftwards" title="Exit Zen Mode">
      <span class="mega-octicon octicon-screen-normal"></span>
    </a>
    <a href="#" class="theme-switcher js-theme-switcher tooltipped leftwards"
      title="Switch themes">
      <span class="octicon octicon-color-mode"></span>
    </a>
  </div>
</div>



    <div id="ajax-error-message" class="flash flash-error">
      <span class="octicon octicon-alert"></span>
      Something went wrong with that request. Please try again.
      <a href="#" class="octicon octicon-remove-close ajax-error-dismiss"></a>
    </div>

    
    
    <span id='server_response_time' data-time='0.15487' data-host='fe19'></span>
    
  </body>
</html>

