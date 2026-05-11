import { useState, useMemo } from 'react';
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

type SpellPool = {
  name: string;
  remaining: number;
  max: number;
};

type Data = {
  user_points?: number;
  spell_pools?: SpellPool[];
  hide_unavailable: boolean;
  spells: Spell[];
};

type SortDirection = 'asc' | 'desc';

export const SpellLibrary = () => {
  const { act, data } = useBackend<Data>(); 

  const [sortDirection, setSortDirection] = useState<SortDirection>('asc'); 
  const [activeTier, setActiveTier] = useState<number | null>(null);

  if (!data) {
    return (
      <Window title="Grimoire of Arcane Arts" width={700} height={600} theme="dark">
        <Window.Content>Loading...</Window.Content>
      </Window>
    );
  }

  const { user_points, spell_pools, hide_unavailable, spells = [] } = data;

  const uniqueTiers = useMemo(() => {
    return Array.from(new Set(spells.map(s => s.tier))).sort((a, b) => a - b);
  }, [spells]);

  const processedSpells = useMemo(() => {
    let result = [...spells];
    if (activeTier !== null) {
      result = result.filter(s => s.tier === activeTier);
    }
    result.sort((a, b) => {
      const diff = a.cost - b.cost;
      return sortDirection === 'asc' ? diff : -diff;
    });
    return result;
  }, [spells, activeTier, sortDirection]);


  const btnBaseStyle = (isActive: boolean) => ({
    minWidth: '40px', 
    textAlign: 'center' as const,
    border: `1px solid ${isActive ? '#4caf50' : '#444'}`,
    backgroundColor: isActive ? '#4caf50' : '#2c3038',
    color: isActive ? '#fff' : '#c5c6c7',
    lineHeight: '18px',
    fontSize: '11px',
    padding: '2px 8px',
    cursor: 'pointer' as const,
    userSelect: 'none' as const,
    borderRadius: '3px',
    marginLeft: '4px',
    transition: 'all 0.1s ease-in-out'
  });

  return (
    <Window
      title="Grimoire of Arcane Arts"
      width={700}
      height={650}
      theme="dark"
    >
      <Window.Content>
        <div style={{ 
          display: 'flex', 
          flexDirection: 'column' as const, 
          height: '100%',
          backgroundImage: 'url("bg_texture.png")', 
          backgroundSize: 'cover',
          backgroundAttachment: 'fixed',
          padding: '8px',
          backgroundColor: '#0b0c10'
        }}>
          
          <div style={{ 
            padding: '8px 12px',
            marginBottom: '6px', 
            backgroundColor: 'rgba(11, 12, 16, 0.95)',
            border: '1px solid #666', 
            borderRadius: '4px',
            display: 'flex', 
            justifyContent: 'space-between' as const, 
            alignItems: 'center',
            boxShadow: '0 4px 10px rgba(0,0,0,0.5)'
          }}>
            <div style={{ display: 'flex', gap: '15px', flexWrap: 'wrap' as const }}>
              {user_points !== undefined && (
                <div style={{ color: '#c5c6c7', fontWeight: 'bold' as const, fontSize: '1.1em' }}>
                  Energy: {user_points}
                </div>
              )}
              {spell_pools?.map(pool => (
                <div key={pool.name} style={{ borderRight: '1px solid #444', paddingRight: '10px' }}>
                  <span style={{ color: '#888', fontSize: '10px', textTransform: 'uppercase' }}>{pool.name}</span>
                  <div style={{ color: '#fff', fontWeight: 'bold' as const }}>{pool.remaining} / {pool.max}</div>
                </div>
              ))}
            </div>

            <div style={{ display: 'flex', alignItems: 'center' }}>
              <div style={{ color: '#888', fontSize: '10px', marginRight: '5px' }}>SORT:</div>
              <div
                className="btn"
                style={btnBaseStyle(true)}
                onClick={() => setSortDirection(d => d === 'asc' ? 'desc' : 'asc')}
              >
                Cost {sortDirection === 'asc' ? '▲' : '▼'}
              </div>
              <div
                className={"btn " + (hide_unavailable ? "selected" : "")}
                style={{ ...btnBaseStyle(hide_unavailable), minWidth: '80px', marginLeft: '10px' }}
                onClick={() => act('toggle_filter')}
              >
                {hide_unavailable ? "Show All" : "Hide Locked"}
              </div>
            </div>
          </div>

          <div style={{
            padding: '4px 10px',
            marginBottom: '8px',
            backgroundColor: 'rgba(31, 40, 51, 0.8)',
            border: '1px solid #444',
            borderRadius: '4px',
            display: 'flex',
            alignItems: 'center',
          }}>
            <div style={{ color: '#888', fontSize: '10px', marginRight: '8px' }}>FILTER BY TIER:</div>
            <div
              style={btnBaseStyle(activeTier === null)}
              onClick={() => setActiveTier(null)}
            >
              All
            </div>
            {uniqueTiers.map(tier => (
              <div
                key={`t-${tier}`}
                style={btnBaseStyle(activeTier === tier)}
                onClick={() => setActiveTier(tier)}
              >
                T{tier}
              </div>
            ))}
          </div>

          <div style={{ 
            flexGrow: 1, 
            overflowY: 'auto', 
            display: 'flex', 
            flexWrap: 'wrap' as const, 
            alignContent: 'flex-start'
          }}>
            {processedSpells.map((spell) => {
              if (hide_unavailable && !spell.is_known && !spell.can_afford) {
                return null;
              }

              const isLocked = !spell.is_known && !spell.can_afford;
              const borderColor = spell.is_known ? '#4caf50' : (isLocked ? '#f44336' : '#666');
              const bgColor = spell.is_known ? 'rgba(27, 38, 27, 0.96)' : 'rgba(31, 40, 51, 0.96)';

              return (
                <div key={spell.path} style={{ 
                  width: '32%', 
                  margin: '0.6%', 
                  boxSizing: 'border-box',
                  display: 'flex'
                }}>
                  <div className="candystripe" style={{ 
                    border: `1px solid ${borderColor}`,
                    padding: '10px',
                    display: 'flex',
                    flexDirection: 'column' as const,
                    width: '100%',
                    opacity: isLocked ? 0.7 : 1,
                    backgroundColor: bgColor,
                    borderRadius: '4px',
                    boxShadow: '0 4px 6px rgba(0,0,0,0.3)',
                  }}>
                    
                    <div style={{ display: 'flex', justifyContent: 'space-between' as const, marginBottom: '6px' }}>
                      <span style={{ fontWeight: 'bold' as const, color: '#fff', fontSize: '12px', whiteSpace: 'nowrap' as const, overflow: 'hidden', textOverflow: 'ellipsis' }}>
                        {spell.name}
                      </span>
                      <span style={{ background: borderColor, color: '#000', padding: '0px 5px', fontSize: '10px', borderRadius: '3px', fontWeight: 'bold' as const }}>
                        T{spell.tier}
                      </span>
                    </div>

                    <div style={{ display: 'flex', marginBottom: '8px', gap: '8px' }}>
                       <div style={{ 
                          width: '54px', height: '54px', 
                          border: '1px solid #444', background: '#000',
                          flexShrink: 0, padding: '2px'
                       }}>
                          {spell.img64 ? (
                            <img 
                              src={`data:image/png;base64,${spell.img64}`} 
                              style={{ width: '100%', height: '100%', imageRendering: 'pixelated' as const }} 
                            />
                          ) : (
                            <div style={{ textAlign: 'center' as const, lineHeight: '50px', color: '#444' }}>?</div>
                          )}
                       </div>
                       <div style={{ fontSize: '10.5px', color: '#aab', height: '52px', overflow: 'hidden', lineHeight: '1.2' }}>
                         {spell.desc}
                       </div>
                    </div>

                    
                    <div style={{ marginTop: 'auto' }}>
                      {spell.is_known ? (
                        <div style={{ 
                            width: '100%', textAlign: 'center' as const, border: '1px solid #4caf50', 
                            color: '#4caf50', padding: '3px 0', fontSize: '10px', fontWeight: 'bold' as const
                        }}>
                          LEARNED
                        </div>
                      ) : (
                        <div
                           className={"btn " + (spell.can_afford ? "" : "disabled")}
                           onClick={() => spell.can_afford && act('learn', { path: spell.path })}
                           style={{ 
                             width: '100%', 
                             textAlign: 'center' as const,
                             backgroundColor: spell.can_afford ? '#2e7d32' : '#2c3038', 
                             color: spell.can_afford ? '#fff' : '#777',
                             fontWeight: 'bold' as const,
                             fontSize: '10px',
                             border: spell.can_afford ? '1px solid #4caf50' : '1px solid transparent',
                             padding: '4px 0',
                             cursor: (spell.can_afford ? 'pointer' : 'default') as const,
                             borderRadius: '3px'
                           }}
                        >
                          {spell.can_afford ? `WEAVE (${spell.cost} PT)` : `LOCKED (${spell.cost} PT)`}
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
