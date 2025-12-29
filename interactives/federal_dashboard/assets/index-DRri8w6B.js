(function(){const i=document.createElement("link").relList;if(i&&i.supports&&i.supports("modulepreload"))return;for(const t of document.querySelectorAll('link[rel="modulepreload"]'))o(t);new MutationObserver(t=>{for(const a of t)if(a.type==="childList")for(const s of a.addedNodes)s.tagName==="LINK"&&s.rel==="modulepreload"&&o(s)}).observe(document,{childList:!0,subtree:!0});function n(t){const a={};return t.integrity&&(a.integrity=t.integrity),t.referrerPolicy&&(a.referrerPolicy=t.referrerPolicy),t.crossOrigin==="use-credentials"?a.credentials="include":t.crossOrigin==="anonymous"?a.credentials="omit":a.credentials="same-origin",a}function o(t){if(t.ep)return;t.ep=!0;const a=n(t);fetch(t.href,a)}})();const h="data/md_impact_analysis.json",b="data/counties.geojson",m=new Intl.NumberFormat("en-US",{style:"currency",currency:"USD",maximumFractionDigits:0}),w=r=>r?new Date(r).toLocaleDateString("en-US",{month:"short",day:"numeric",year:"numeric"}):"N/A";async function _(){try{const[r,i]=await Promise.all([fetch(h),fetch(b)]);if(!r.ok)throw new Error(`Impact data failed: ${r.statusText}`);if(!i.ok)throw new Error(`Geo data failed: ${i.statusText}`);const n=await r.json(),o=await i.json();x(n.meta.generated_at),v(n);const t=o.features||o;C(t,n.visualization_data.breakdown_by_county),T(n.visualization_data.breakdown_by_county),$(n.raw_impact_events.tier1)}catch(r){console.error("Dashboard Crash Details:",r),document.querySelector("main").innerHTML=`
      <div style="text-align:center; padding: 4rem; color: #BF0D3E;">
        <h2 style="margin-bottom: 1rem;">Unable to Load Dashboard</h2>
        <p style="color: #374151; margin-bottom: 0.5rem;">
          We encountered an issue processing the data.
        </p>
        <code style="background: #eee; padding: 0.2rem 0.4rem; border-radius: 4px; font-size: 0.85rem;">
          ${r.message}
        </code>
      </div>
    `}}function x(r){const i=new Date(r);document.getElementById("last-updated").textContent=`Last Updated: ${i.toLocaleString()}`}function v(r){const i=r.summary_stats,n=r.visualization_data,o=document.getElementById("topline-container"),t=(f,y,g,u)=>`
    <div class="stat-card ${u}">
      <div class="stat-label">${f}</div>
      <div class="stat-value text-${u}">${y}</div>
      <div class="stat-sub">${g}</div>
    </div>
  `,a=new Set;r.raw_impact_events&&r.raw_impact_events.tier1&&r.raw_impact_events.tier1.forEach(f=>{f.recipient&&a.add(f.recipient.trim())});const s=a.size,d=n.breakdown_by_program.length;o.innerHTML=`
    ${t("Total Identified Cuts",m.format(Math.abs(i.tier1_confirmed_cuts.total_amount)),`${i.tier1_confirmed_cuts.count} transactions confirmed as policy cuts`,"tier1")}
    ${t("Unique Recipients",s,"Maryland organizations facing reductions","tier2")}
    ${t("Programs Impacted",d,"Specific grant/contract lines affected","admin")}
  `}function T(r){const i=document.getElementById("county-breakdown-list");let n=0;const o=[];r.forEach(s=>{const d=s.county_name.toUpperCase();d.includes("STATEWIDE")||d.includes("UNKNOWN")||d.includes("CENTRALIZED")?n+=s.total_loss:o.push(s)}),o.sort((s,d)=>d.total_loss-s.total_loss);const t=o.map(s=>`
    <tr>
      <td style="padding: 8px 1.5rem; border-bottom: 1px solid #f3f4f6; color: #111; font-weight: 500;">
        ${s.county_name}
      </td>
      <td style="padding: 8px 1.5rem; border-bottom: 1px solid #f3f4f6; text-align: right; color: #BF0D3E; font-weight: 600;">
        ${m.format(s.total_loss)}
      </td>
    </tr>
  `).join(""),a=n>0?`
    <tr style="background-color: #f9fafb;">
      <td style="padding: 8px 1.5rem; border-bottom: 1px solid #f3f4f6; color: #6b7280; font-style: italic;">
        Statewide / Uncategorized
      </td>
      <td style="padding: 8px 1.5rem; border-bottom: 1px solid #f3f4f6; text-align: right; color: #BF0D3E;">
        ${m.format(n)}
      </td>
    </tr>
  `:"";i.innerHTML=`
    <table style="width: 100%; border-collapse: collapse; font-size: 0.9rem;">
      <thead style="position: sticky; top: 0; z-index: 10; box-shadow: 0 1px 2px rgba(0,0,0,0.05);">
        <tr>
          <th style="text-align: left; padding: 12px 1.5rem 8px 1.5rem; background-color: #ffffff; color: #6b7280; font-size: 0.8rem; border-bottom: 2px solid #e5e7eb;">COUNTY</th>
          <th style="text-align: right; padding: 12px 1.5rem 8px 1.5rem; background-color: #ffffff; color: #6b7280; font-size: 0.8rem; border-bottom: 2px solid #e5e7eb;">REDUCTION</th>
        </tr>
      </thead>
      <tbody>
        ${t}
        ${a}
      </tbody>
    </table>
  `}function $(r){const i=document.getElementById("cuts-table-body"),n=r.sort((o,t)=>o.amount-t.amount);i.innerHTML=n.map(o=>`
    <tr>
      <td style="white-space:nowrap; color: #6b7280; font-size: 0.85rem;">${w(o.date)}</td>
      <td style="font-weight: 500;">${o.agency}</td>
      <td>
        <div style="font-weight:600; color: #111;">${o.recipient||"Unknown"}</div>
        <div style="font-size:0.8rem; color:#6b7280">${o.county?.county_name||"Statewide"}, MD</div>
      </td>
      <td style="max-width:300px; font-size:0.85rem; line-height: 1.4; color: #374151;">
        ${o.description}
      </td>
      <td class="text-right" style="color: #BF0D3E; font-weight: 700; white-space:nowrap;">
        ${m.format(o.amount)}
      </td>
    </tr>
  `).join("")}function C(r,i){const n=e=>e?e.toUpperCase().replace(" COUNTY","").replace(/\./g,"").replace(/'/g,"").replace(/\bSAINT\b/g,"ST").trim():"",o=L.map("map").setView([39,-77.1],7);L.tileLayer("https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}{r}.png",{maxZoom:19,attribution:'&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors &copy; <a href="https://carto.com/attributions">CARTO</a>'}).addTo(o);const t={};i.forEach(e=>{const c=n(e.county_name);t[c]=e.total_loss});function a(e){return e>1e7?"#7f0000":e>5e6?"#b30000":e>2e6?"#d7301f":e>1e6?"#ef6548":e>5e5?"#fc8d59":e>1e5?"#fdbb84":e>10?"#fdd49e":"#374151"}function s(e){const c=e.properties||{},p=n(c.COUNTY),l=t[p]||0;return{fillColor:a(l),weight:1,opacity:1,color:"#1f2937",dashArray:"1",fillOpacity:.8}}const d=L.control();d.onAdd=function(e){return this._div=L.DomUtil.create("div","info"),this.update(),this._div},d.update=function(e){if(!e){this._div.innerHTML='<h4 style="margin:0; color:#374151;">County Impact</h4><span style="font-size:0.9em; color:#6b7280">Hover over a county</span>';return}const c=(e.COUNTY||"").toUpperCase(),p=n(e.COUNTY),l=t[p]||0;this._div.innerHTML=`<h4 style="margin:0 0 5px 0; color:#111;">${c}</h4>`+(l?`<b style="font-size:1.1em; color:#BF0D3E;">${m.format(l)}</b> lost`:'<span style="color:#6b7280">No identified cuts</span>')},d.addTo(o);function f(e){var c=e.target;c.setStyle({weight:3,color:"#d1d5db",dashArray:"",fillOpacity:1}),c.bringToFront(),d.update(c.feature.properties)}function y(e){g.resetStyle(e.target),d.update()}const g=L.geoJson(r,{style:s,onEachFeature:function(e,c){c.on({mouseover:f,mouseout:y})}}).addTo(o),u=L.control({position:"bottomright"});u.onAdd=function(e){const c=L.DomUtil.create("div","info legend"),p=[0,1e5,5e5,1e6,2e6,5e6,1e7];c.innerHTML='<strong style="display:block; margin-bottom:5px; color:#374151;">Loss Amount</strong>';for(let l=0;l<p.length;l++)c.innerHTML+='<i style="background:'+a(p[l]+1)+'; width:18px; height:18px; float:left; margin-right:8px; opacity:0.8;"></i> <span style="color:#4b5563;">$'+(p[l]/1e6).toFixed(1)+"M"+(p[l+1]?"&ndash;$"+(p[l+1]/1e6).toFixed(1)+"M</span><br>":"+</span>");return c},u.addTo(o)}_();
