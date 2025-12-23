(function(){const a=document.createElement("link").relList;if(a&&a.supports&&a.supports("modulepreload"))return;for(const t of document.querySelectorAll('link[rel="modulepreload"]'))r(t);new MutationObserver(t=>{for(const s of t)if(s.type==="childList")for(const i of s.addedNodes)i.tagName==="LINK"&&i.rel==="modulepreload"&&r(i)}).observe(document,{childList:!0,subtree:!0});function n(t){const s={};return t.integrity&&(s.integrity=t.integrity),t.referrerPolicy&&(s.referrerPolicy=t.referrerPolicy),t.crossOrigin==="use-credentials"?s.credentials="include":t.crossOrigin==="anonymous"?s.credentials="omit":s.credentials="same-origin",s}function r(t){if(t.ep)return;t.ep=!0;const s=n(t);fetch(t.href,s)}})();const g="data/md_impact_analysis.json",h="data/counties.geojson",u=new Intl.NumberFormat("en-US",{style:"currency",currency:"USD",maximumFractionDigits:0}),b=o=>o?new Date(o).toLocaleDateString("en-US",{month:"short",day:"numeric",year:"numeric"}):"N/A";async function w(){try{const[o,a]=await Promise.all([fetch(g),fetch(h)]);if(!o.ok)throw new Error(`Impact data failed: ${o.statusText}`);if(!a.ok)throw new Error(`Geo data failed: ${a.statusText}`);const n=await o.json(),r=await a.json();_(n.meta.generated_at),x(n);const t=r.features||r;$(t,n.visualization_data.breakdown_by_county),v(n.visualization_data.breakdown_by_county),T(n.raw_impact_events.tier1)}catch(o){console.error("Dashboard Crash Details:",o),document.querySelector("main").innerHTML=`
      <div style="text-align:center; padding: 4rem; color: #BF0D3E;">
        <h2 style="margin-bottom: 1rem;">Unable to Load Dashboard</h2>
        <p style="color: #374151; margin-bottom: 0.5rem;">
          We encountered an issue processing the data.
        </p>
        <code style="background: #eee; padding: 0.2rem 0.4rem; border-radius: 4px; font-size: 0.85rem;">
          ${o.message}
        </code>
      </div>
    `}}function _(o){const a=new Date(o);document.getElementById("last-updated").textContent=`Last Updated: ${a.toLocaleString()}`}function x(o){const a=o.summary_stats,n=o.visualization_data,r=document.getElementById("topline-container"),t=(f,y,m,e)=>`
    <div class="stat-card ${e}">
      <div class="stat-label">${f}</div>
      <div class="stat-value text-${e}">${y}</div>
      <div class="stat-sub">${m}</div>
    </div>
  `,s=new Set;o.raw_impact_events&&o.raw_impact_events.tier1&&o.raw_impact_events.tier1.forEach(f=>{f.recipient&&s.add(f.recipient.trim())});const i=s.size,l=n.breakdown_by_program.length;r.innerHTML=`
    ${t("Total Identified Cuts",u.format(Math.abs(a.tier1_confirmed_cuts.total_amount)),`${a.tier1_confirmed_cuts.count} transactions confirmed as policy cuts`,"tier1")}
    ${t("Unique Recipients",i,"Maryland organizations facing reductions","tier2")}
    ${t("Programs Impacted",l,"Specific grant/contract lines affected","admin")}
  `}function v(o){const a=document.getElementById("county-breakdown-list");let n=0;const r=[];o.forEach(i=>{const l=i.county_name.toUpperCase();l.includes("STATEWIDE")||l.includes("UNKNOWN")||l.includes("CENTRALIZED")?n+=i.total_loss:r.push(i)}),r.sort((i,l)=>l.total_loss-i.total_loss);const t=r.map(i=>`
    <tr>
      <td style="padding: 8px 1.5rem; border-bottom: 1px solid #f3f4f6; color: #111; font-weight: 500;">
        ${i.county_name}
      </td>
      <td style="padding: 8px 1.5rem; border-bottom: 1px solid #f3f4f6; text-align: right; color: #BF0D3E; font-weight: 600;">
        ${u.format(i.total_loss)}
      </td>
    </tr>
  `).join(""),s=n>0?`
    <tr style="background-color: #f9fafb;">
      <td style="padding: 8px 1.5rem; border-bottom: 1px solid #f3f4f6; color: #6b7280; font-style: italic;">
        Statewide / Uncategorized
      </td>
      <td style="padding: 8px 1.5rem; border-bottom: 1px solid #f3f4f6; text-align: right; color: #BF0D3E;">
        ${u.format(n)}
      </td>
    </tr>
  `:"";a.innerHTML=`
    <table style="width: 100%; border-collapse: collapse; font-size: 0.9rem;">
      <thead style="position: sticky; top: 0; z-index: 10; box-shadow: 0 1px 2px rgba(0,0,0,0.05);">
        <tr>
          <th style="text-align: left; padding: 12px 1.5rem 8px 1.5rem; background-color: #ffffff; color: #6b7280; font-size: 0.8rem; border-bottom: 2px solid #e5e7eb;">COUNTY</th>
          <th style="text-align: right; padding: 12px 1.5rem 8px 1.5rem; background-color: #ffffff; color: #6b7280; font-size: 0.8rem; border-bottom: 2px solid #e5e7eb;">REDUCTION</th>
        </tr>
      </thead>
      <tbody>
        ${t}
        ${s}
      </tbody>
    </table>
  `}function T(o){const a=document.getElementById("cuts-table-body"),n=o.sort((r,t)=>r.amount-t.amount);a.innerHTML=n.map(r=>`
    <tr>
      <td style="white-space:nowrap; color: #6b7280; font-size: 0.85rem;">${b(r.date)}</td>
      <td style="font-weight: 500;">${r.agency}</td>
      <td>
        <div style="font-weight:600; color: #111;">${r.recipient||"Unknown"}</div>
        <div style="font-size:0.8rem; color:#6b7280">${r.county?.county_name||"Statewide"}, MD</div>
      </td>
      <td style="max-width:300px; font-size:0.85rem; line-height: 1.4; color: #374151;">
        ${r.description}
      </td>
      <td class="text-right" style="color: #BF0D3E; font-weight: 700; white-space:nowrap;">
        ${u.format(r.amount)}
      </td>
    </tr>
  `).join("")}function $(o,a){const n=L.map("map").setView([39,-77.1],7);L.tileLayer("https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}{r}.png",{maxZoom:19,attribution:'&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors &copy; <a href="https://carto.com/attributions">CARTO</a>'}).addTo(n);const r={};a.forEach(e=>{const c=e.county_name.toUpperCase().replace(" COUNTY","").trim();r[c]=e.total_loss});function t(e){return e>1e7?"#7f0000":e>5e6?"#b30000":e>2e6?"#d7301f":e>1e6?"#ef6548":e>5e5?"#fc8d59":e>1e5?"#fdbb84":e>10?"#fdd49e":"#374151"}function s(e){const d=((e.properties||{}).COUNTY||"").toUpperCase(),p=r[d]||0;return{fillColor:t(p),weight:1,opacity:1,color:"#1f2937",dashArray:"1",fillOpacity:.8}}const i=L.control();i.onAdd=function(e){return this._div=L.DomUtil.create("div","info"),this.update(),this._div},i.update=function(e){if(!e){this._div.innerHTML='<h4 style="margin:0; color:#374151;">County Impact</h4><span style="font-size:0.9em; color:#6b7280">Hover over a county</span>';return}const c=e.COUNTY.toUpperCase(),d=r[c]||0;this._div.innerHTML=`<h4 style="margin:0 0 5px 0; color:#111;">${c}</h4>`+(d?`<b style="font-size:1.1em; color:#BF0D3E;">${u.format(d)}</b> lost`:'<span style="color:#6b7280">No identified cuts</span>')},i.addTo(n);function l(e){var c=e.target;c.setStyle({weight:3,color:"#d1d5db",dashArray:"",fillOpacity:1}),c.bringToFront(),i.update(c.feature.properties)}function f(e){y.resetStyle(e.target),i.update()}const y=L.geoJson(o,{style:s,onEachFeature:function(e,c){c.on({mouseover:l,mouseout:f})}}).addTo(n),m=L.control({position:"bottomright"});m.onAdd=function(e){const c=L.DomUtil.create("div","info legend"),d=[0,1e5,5e5,1e6,2e6,5e6,1e7];c.innerHTML='<strong style="display:block; margin-bottom:5px; color:#374151;">Loss Amount</strong>';for(let p=0;p<d.length;p++)c.innerHTML+='<i style="background:'+t(d[p]+1)+'; width:18px; height:18px; float:left; margin-right:8px; opacity:0.8;"></i> <span style="color:#4b5563;">$'+(d[p]/1e6).toFixed(1)+"M"+(d[p+1]?"&ndash;$"+(d[p+1]/1e6).toFixed(1)+"M</span><br>":"+</span>");return c},m.addTo(n)}w();
