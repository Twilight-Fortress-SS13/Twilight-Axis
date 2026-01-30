import { useState } from 'react';
import { useBackend } from '../backend';
import { Window } from '../layouts';

type Spell = {
  name: string;
  desc: string;
  cost: number;
  tier: number;
  path: string;
  img64: string;
  is_known: boolean;
  can_afford: boolean;
};

type Data = {
  user_points: number;
  hide_unavailable: boolean;
  spells: Spell[];
};


type SortDirection = 'asc' | 'desc';

export const SpellLibrary = (props, context) => {
  const { act, data } = useBackend<Data>(); 
  
  if (!data) {
    return (
      <Window title="Grimoire of Arcane Arts" width={700} height={600} theme="dark">
        <Window.Content>Loading Spells...</Window.Content>
      </Window>
    );
  }

  const { user_points, hide_unavailable, spells } = data;

  const [sortDirection, setSortDirection] = useState<SortDirection>('asc'); 
  const [activeTier, setActiveTier] = useState<number | null>(null);


  const getBtnStyle = (isActive: boolean) => ({
    minWidth: '70px', 
    textAlign: 'center',
    border: `1px solid ${isActive ? '#4caf50' : '#2c3038'}`, 
    backgroundColor: isActive ? '#4caf50' : '#2c3038', 
    color: isActive ? '#fff' : '#c5c6c7', 
    lineHeight: '18px',
    fontSize: '11px',
    padding: '2px 6px',
    cursor: 'pointer',
    userSelect: 'none',
    marginLeft: '4px',
    borderRadius: '3px'
  });

  const getTierFilterBtnStyle = (isActive: boolean) => ({
    minWidth: '40px', 
    textAlign: 'center',
    border: `1px solid ${isActive ? '#4caf50' : '#2c3038'}`,
    backgroundColor: isActive ? '#4caf50' : '#2c3038',
    color: isActive ? '#fff' : '#c5c6c7',
    lineHeight: '18px',
    fontSize: '11px',
    padding: '2px 6px',
    cursor: 'pointer',
    userSelect: 'none',
    marginLeft: '4px',
    borderRadius: '3px'
  });

  const uniqueTiers = Array.from(new Set((spells || []).map(spell => spell.tier)))
    .sort((a, b) => a - b);

  const filteredByTierSpells = activeTier !== null
    ? (spells || []).filter(spell => spell.tier === activeTier)
    : (spells || []);

  const sortedAndFilteredSpells = [...filteredByTierSpells].sort((a, b) => {
    const comparison = a.cost - b.cost;
    return sortDirection === 'asc' ? comparison : -comparison;
  });

  return (
    <Window
      title="Grimoire of Arcane Arts"
      width={700}
      height={600}
      theme="dark"
    >
      <Window.Content>
        <div style={{ 
          display: 'flex', 
          flexDirection: 'column', 
          height: '100%',
          backgroundImage: 'url("bg_texture.png")', 
          backgroundSize: 'cover',
          backgroundAttachment: 'fixed',
          padding: '6px'
        }}>
          
          <div style={{ 
            padding: '6px 10px',
            marginBottom: '6px', 
            backgroundColor: 'rgba(11, 12, 16, 0.95)',
            border: '1px solid #666', 
            borderRadius: '4px',
            display: 'flex', 
            justifyContent: 'space-between', 
            alignItems: 'center',
            boxShadow: '0 4px 6px rgba(0,0,0,0.5)',
            flexShrink: 0
          }}>
            <div style={{ color: '#c5c6c7', fontWeight: 'bold', fontSize: '1.1em', textShadow: '1px 1px 2px black', marginRight: 'auto' }}>
              Point: {user_points}
            </div>

            <div style={{ display: 'flex', marginRight: '10px' }}>
              <div style={{ color: '#888', fontSize: '10px', marginRight: '5px', alignSelf: 'center' }}>Sort by:</div>
              <div
                className={"btn selected"} 
                onClick={() => setSortDirection(prev => prev === 'asc' ? 'desc' : 'asc')}
                style={getBtnStyle(true)} 
              >
                Cost {sortDirection === 'asc' ? '▲' : '▼'}
              </div>
            </div>
            
            <div
              className={"btn " + (hide_unavailable ? "selected" : "")}
              onClick={(e) => {
                e.preventDefault();
                e.stopPropagation();
                act('toggle_filter');
              }}
              style={getBtnStyle(hide_unavailable)} 
            >
              {hide_unavailable ? "Show All" : "Hide Locked"}
            </div>
          </div>

          <div style={{
            padding: '6px 10px',
            marginBottom: '6px',
            backgroundColor: 'rgba(11, 12, 16, 0.95)',
            border: '1px solid #666', 
            borderRadius: '4px',
            display: 'flex',
            alignItems: 'center',
            boxShadow: '0 4px 6px rgba(0,0,0,0.5)',
            flexShrink: 0
          }}>
            <div style={{ color: '#888', fontSize: '10px', marginRight: '5px' }}>Filter by Tier:</div>
            <div
              className={"btn " + (activeTier === null ? "selected" : "")}
              onClick={() => setActiveTier(null)}
              style={getTierFilterBtnStyle(activeTier === null)}
            >
              All
            </div>
            {uniqueTiers.map(tier => (
              <div
                key={`tier-${tier}`}
                className={"btn " + (activeTier === tier ? "selected" : "")}
                onClick={() => setActiveTier(tier)}
                style={getTierFilterBtnStyle(activeTier === tier)}
              >
                T{tier}
              </div>
            ))}
          </div>

          <div style={{ 
            flex: '1', 
            overflowY: 'auto', 
            display: 'flex', 
            flexWrap: 'wrap', 
            alignContent: 'flex-start',
            paddingRight: '2px'
          }}>
            {sortedAndFilteredSpells.map((spell) => {
              if (hide_unavailable && !spell.is_known && !spell.can_afford) {
                return null;
              }

              const isLocked = !spell.is_known && !spell.can_afford;
              const borderColor = spell.is_known ? '#4caf50' : (isLocked ? '#f44336' : '#666');
              const opacity = isLocked ? 0.75 : 1;
              const bgColor = spell.is_known ? 'rgba(27, 38, 27, 0.95)' : 'rgba(31, 40, 51, 0.95)';

              return (
                <div key={spell.path} style={{ 
                  width: '32%', 
                  margin: '0.6%', 
                  boxSizing: 'border-box',
                  display: 'flex',
                  flexDirection: 'column'
                }}>
                  <div className="candystripe" style={{ 
                    border: `1px solid ${borderColor}`,
                    padding: '12px',
                    display: 'flex',
                    flexDirection: 'column',
                    height: '100%',
                    opacity: opacity,
                    backgroundColor: bgColor,
                    borderRadius: '4px',
                    boxShadow: '0 2px 4px rgba(0,0,0,0.5)',
                    position: 'relative'
                  }}>
                    
                    <div style={{ display: 'flex', justifyContent: 'space-between', marginBottom: '4px' }}>
                      <span style={{ fontWeight: 'bold', color: '#fff', whiteSpace: 'nowrap', overflow: 'hidden', textOverflow: 'ellipsis', fontSize: '12px' }}>
                        {spell.name}
                      </span>
                      <span style={{ background: borderColor, color: '#0b0c10', padding: '0px 4px', fontSize: '10px', borderRadius: '3px', fontWeight: 'bold', lineHeight: '14px' }}>
                        T{spell.tier}
                      </span>
                    </div>

                    <div style={{ display: 'flex', marginBottom: '4px', backgroundColor: 'rgba(0,0,0,0.3)', padding: '3px', borderRadius: '3px' }}>
                       <div style={{ 
                          width: '64px', height: '64px', marginRight: '6px', 
                          border: '1px solid #333', background: '#000',
                          flexShrink: 0,
                          display: 'flex', alignItems: 'center', justifyContent: 'center'
                       }}>
                          {spell.img64 ? (
                            <img 
                              src={`data:image/png;base64,${spell.img64}`} 
                              style={{ maxWidth: '100%', maxHeight: '100%', imageRendering: 'pixelated' }} 
                            />
                          ) : (
                            <span style={{ color: '#555', fontSize: '16px' }}>?</span>
                          )}
                       </div>
                       <div style={{ fontSize: '10px', color: '#aab', height: '4.4em', overflow: 'hidden', lineHeight: '1.1' }}>
                         {spell.desc}
                       </div>
                    </div>

                    <div style={{ marginTop: 'auto' }}>
                      {spell.is_known ? (
                        <div className="btn disabled" style={{ 
                            width: '100%', textAlign: 'center', 
                            border: '1px solid #4caf50', color: '#4caf50', background: 'transparent',
                            fontWeight: 'bold', fontSize: '10px', padding: '1px 0', lineHeight: '16px'
                        }}>
                          LEARNED
                        </div>
                      ) : (
                        <div
                           className={"btn " + (spell.can_afford ? "" : "disabled")}
                           onClick={(e) => {
                             e.preventDefault();
                             e.stopPropagation();
                             if (spell.can_afford) {
                               act('learn', { path: spell.path });
                             }
                           }}
                           style={{ 
                             width: '100%', 
                             textAlign: 'center',
                             backgroundColor: spell.can_afford ? '#2e7d32' : '#2c3038', 
                             color: spell.can_afford ? '#fff' : '#555',
                             fontWeight: 'bold',
                             fontSize: '10px',
                             border: spell.can_afford ? '1px solid #4caf50' : '1px solid transparent',
                             boxShadow: spell.can_afford ? '0 0 5px rgba(76, 175, 80, 0.4)' : 'none',
                             transition: 'all 0.2s',
                             lineHeight: '16px',
                             padding: '1px 0',
                             cursor: spell.can_afford ? 'pointer' : 'default',
                             userSelect: 'none'
                           }}
                        >
                          {spell.can_afford ? `WEAVE (${spell.cost} PT)` : `${spell.cost} PT REQUIRED`}
                        </div>
                      )}
                    </div>

                  </div>
                </div>
              );
            })}
          </div>

        </div>
      </Window.Content>
    </Window>
  );
};
