import React from 'react';
import {
  Box,
  Button,
  Stack,
} from 'tgui-core/components';
import { useBackend } from '../backend';
import { Window } from '../layouts';
import { resolveAsset } from '../assets';
import { useState } from 'react';
import type { ManorPanelData, WorkstationData } from './ManorPanelData';

const GOD_ICONS: Record<string, string> = {
  'abyssor': 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAMAAABEpIrGAAAAM1BMVEX////1tACOnLkoOV0NGTFKYZNBVoMbKksuQWogMVggGw8SHDR+i6cIEy4LEBppdZASIUYydIarAAAAAXRSTlMAQObYZgAAAHV6VFh0RGVzY3JpcHRpb24AAHicU1ZwcnX39FNw8fXkKkstKs7Mz1OwVTDRM+DiLM9MKckAcoyNuDgzUjPTM0ognOKSxJJUIFOpODM9L94xqbK4OL9IiYszJbOoGChsyMWZVpSYmwpl5+TnF4BZygqufi5gewBYux95NFLtQQAAAKxJREFUOI3tks0OwjAMg5c4f2Vl3fs/LSkSXJpxQ+KAe/QnN3G7bX/9pOilS5sZkqcmiMCsZnCXiph+qEWEAxVBiPTdXdWb3BYgA6a/d1VTiKxABpjtzOw5RlsAonnBzv3eu3krANgE+nEcI6KhAMImwMdIAAUgbhp+9jEQucWyJgEeueT59NeAHFLgWRMwiyp7SiLnSNuLCd4ZnhGzpYvHInnq8rm3z7/he3oAYjgE/vh2GAEAAAAASUVORK5CYII=',
  'astrata': 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgBAMAAACBVGfHAAAAFVBMVEX////1tADGhSqhVSEiFAJtJxHsvkBsfhq9AAAAAXRSTlMAQObYZgAAAHV6VFh0RGVzY3JpcHRpb24AAHicU1ZwcnX39FNw8fXkKkstKs7Mz1OwVTDRM+DiLM9MKckAcoyNuDgzUjPTM0ognOKSxJJUIFOpODM9L96xuKQosSRRiYszJbOoGChsyMWZVpSYmwpl5+TnF4BZygqufi5gewBVgx9mN9SynQAAALFJREFUKJGN0TEWwiAMBmC4AT+Ie7DtzrN077McwJZcQO9/B59DS4OL2fhIgASl/gpAA0bjABvRbQAd4Bd0D3CsJWW+zG6rJRrFzwmmnqp9Xp+ntVJuWaMSUCYJGAcJOg2QMA6mgamB8gNtCb8kgF/yFsc3kpB7CT4n8VLtOIluUe6BcU7IjvpYU5Cio3cdIfwKR9cUd/FMxhLCMXYfoCxpm/aM76/5aCDGzqHpVmyL+ABwThh3CSe5BgAAAABJRU5ErkJggg==',
  'baotha': 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgBAMAAACBVGfHAAAAIVBMVEX///+2AABUG2qsWMydNHG7SKk/ElFtFDdAAwMxC0AOBQCkUgrcAAAAAXRSTlMAQObYZgAAAR5JREFUKJGVkUFqwzAQRa0b6BuZ0KXl0gM0J1CQKqe7FLvNAYJClwIT18usSpYFU6Pbdiw5pMv2Lwb0JM3X12TZX8QAfq1pXUmQZLUQyHu5fqzWclMlkJfmRZIOOke8kRcwTj64HpsyAmognpw7KqCc7zCq4tW5ztNeBMiYaGbAWb4Y4007p2tk0RecFZ+WgD5zNtvkHPsVNT14CzbbkMdOOJIXHvEhMLAzsKjTw+jA8H06utGLc7Q1yoZwmkLQ4jkBcQlhGEOYVAINgWk7DgTqBIpL6O6+LAG7gO0M9PvoEyjQ9moYhbVQMUuhoDGMVIRP0RpgpTV9h0X65KJtbKM706presDsxAdSkjQIAwrCb5MyDWe6/wVoaLfB/Vs/JeFKAEBYuggAAAAASUVORK5CYII=',
  'dendor': 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgBAMAAACBVGfHAAAAJFBMVEX////1tAAycSgbXBkzky5DqjsdPg6JZFpSOjKgeG5nTEc0Hh6IUABHAAAAAXRSTlMAQObYZgAAAPlJREFUKJGdkTGOwyAURM0NmA1ebLZC9gUcKQcgax8gUXwQKsfpaHOBldJRIaXLDRfMBqiXwuCnmc/8T1X9cxH4Rcv/rv/eAxnIj8NRYshA4XAGKxQj6hOONFVAfWGnWb7rYgYmps5AtwGyw3Spp1H2XVRgABibe6n+HDufSWHa+1si+cSsQLihYP1GMIaIrfGneHMUtjYG8F+2GTdQkSEDHZsKFhq0XMf9HX65O1cMBOuD2/Und8sfWBY8beq+NVgEhE79r4ZoQZtrAs4SKyjPQGhYoXmyVLh5YF0xUw+4dUWOawD3rBBG+BqNTqB5+bL4MtmCMIj4lL/TRDJ3FUZBRgAAAABJRU5ErkJggg==',
  'eora': 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgBAMAAACBVGfHAAAAFVBMVEX////1tACYwMi85uJdg5gzQWsWEDkHgOmjAAAAAXRSTlMAQObYZgAAANhJREFUKJG9kf2RhSAMxKGDbKSB8HH/q3cFxPEKcOb1X8slgo9XwTkDws9ls8QQ/u2JAPmYoGwU8/kBUCi2qQAc/NprfF/2rQBH2aVrsAFJWIDaJYsgQ9km1n4C+ynKXCvuM3FbGg6Y4NA6wOWgmtEAfEUzVUrSblD4Ijc1+tWBVERNhMwd8MoKTVbUpHewYoZw19aDucRWZqPjevhJQpF1JPesr2r9yNe8/3c20B6Bu1jHDp0dC7w6eG8BlmA5n46FxZIYPiGPoqzkRvldlu8VZJal/jN8/gMrGxwWsYmDJgAAAABJRU5ErkJggg==',
  'graggar': 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAMAAABEpIrGAAAAS1BMVEX///+2AAA+FQgaDwwxIx1KPzc+CghCAwNCBgMFAwNGCgZGEQ9FCARGHA9LIhVQHRtQKBtCEQNxbGVFAwJLFxVFBQRGBwZMFQlKKhJHWqphAAAAAXRSTlMAQObYZgAAAPNJREFUOI290ttyhCAMBmB/CFiN7K6UHt7/SZugdRtgetOZcsFo8k0SkWn6nwXg9xhcL+ANoBagA42At+AsAZytMQDQtJc4jnwDVGg0BI/jyQCQi7OEg6xa5Kz0Q7iXGMkHCiS5pc1X4WiNHCpoGlxdtsRMBxicLeiWUuJISpbR0VNKziUF1E1QC9w3/VoBENGXAD02mXTf5TzGIN9YJtt32ZYBQAWTgklB/5XZAOqmRH6sXH+Xbv0QUDB/xwY9pMP6+gSDCgLKmwX2Z+Zc3m0LU0LzpXxc4LPtgXwvha+bLdelBzwznhU8Fm9nuK7z4PWv6wv+6gf3mnL0dgAAAABJRU5ErkJggg==',
  'malum': 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgBAMAAACBVGfHAAAAElBMVEX////1tAChVSHsvkDGhSptJxG+2xVSAAAAAXRSTlMAQObYZgAAAJNJREFUKJHNkNEZwiAMhMkGCdQBiHWB4gJoHEA/2H8VQysN9s037/H/cscdzv2xaNcH+HNKSaSW3AGzCKs6CMtm8M+ecY+4XnYA00JfYDsB8j1jPUGoHK1JYoQiBoBuCI+9WCNXBTi2PwAKCubBEZJmXPIARJ89ZTRH6+4LmSO2ceYJOn0Wm+8mqfXFtdq4wxf+qDdqqxU5Sl6/FgAAAABJRU5ErkJggg==',
  'matthios': 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgBAMAAACBVGfHAAAAJFBMVEX///+2AAB4JY2XO51WD1xECUCshDHt/6ThxWJ4Qh1CChM0CzxWM7yVAAAAAXRSTlMAQObYZgAAAQdJREFUKJG1kD1Ow0AQhTM38PPG9N6sLUgXG0Vp/YfichJvpLSRC3IABHXECSwKRGlxAiSqXI6187dBomS6/fbNG703GPzbwAEIFnAhJkhshXInylaQm6bsWG+obKFxIYhrUcnivAPxzIKzKR8JiZlil7209o9gvmMIhg6TgwvVZlskhFQ5/QXcmJ8OFIBxoWbuo1fkPBwaF9rMlvcMNwHy4LMD9fRpFOkFp7FctSYPeeKlzKJcB7ne+l1AjG4fXj+kXIdNI7k/E413j22xDVsJHKKNm/dNUZbtKR7F0V29aip1ikveMnpbB/tLI0CmvhhWZeTl33aDRqP3zhUgr7oGxuYX+Ht+AKnWMUFBxmryAAAAAElFTkSuQmCC',
  'necra': 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgBAMAAACBVGfHAAAAFVBMVEX////1tAAzNFNHRHUkIT5ZVowQEyDIhF4cAAAAAXRSTlMAQObYZgAAANtJREFUKJGdkcGVwyAMRK0OPAgKIDgFAHbuYpMCHD8X4Mv2X8ISHNtwXR3/G83TjLruv0NA3wC4sSGkXmFELYivd9wuCXgxc3qcEuLV86ydPSRYPdhDBRyC7Gd8NrL4CqL0xpKOsSyRsRhhBD9QYwFvkBYW7XvcCpj7jr3ZtM/3ncCaTZ0ggHaA7woX0w3O7qYdpmXAlHLgtCemT/Y1g9+jAVKBl+QfVyNwU3TJX/EJE9unrRsLbIe6MWIlQ9OyVpKakjOQBiQloQIEyQVUj6Fw03Jf6jvKtM885g8qPCDvrkj3EQAAAABJRU5ErkJggg==',
  'noc': 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgBAMAAACBVGfHAAAAHlBMVEX////1tAA/WXhlhY6LsbfU7OfF091IS1MOER0lK0slQiSPAAAAAXRSTlMAQObYZgAAAOhJREFUKJGNkcF1wyAQRHc7YLRQAJJcgCJ8yBGBC8iz3EGKSBtxxVlksPEte9Hjv9HsDBD9c6DzBoaw+f7Mckq9gvF9unb/MM63y377ehKc9zRfw2UxFdh9/ZkjQrNhtwAusuQq4QjObimrKwCrwhPsczWysb58fDOJRhXEoZpgB6kHsa0mLpkDkDSgShdLxfwA1huyPSjKA0iqpgFke1OWaA4wV6CJUADmR44SXRTwUJMe5US7TLUL2wiI56ElJ8kr5FcvaGllQ/6Y7jn51p6x5u2ePl8vo1u2aRz7l9EcIwz1BO/n1/wB+j8iadz0UgcAAAAASUVORK5CYII=',
  'pestra': 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgBAMAAACBVGfHAAAAJFBMVEX////1tAAZPi5LllTZpylPLRmi2VXs2ktgMV2YZxUXJSoqFxeo/PsKAAAAAXRSTlMAQObYZgAAANVJREFUKJFjYKAECAoKoPAZhYwF4WxBEDBWCRSA8c2S05TN0sydoQKCbckdZhoWHZ2TIAKMEslNQB1Sxi5QUxnbmqYCWcJGrjAdGZUgKeGWiVABicxCIItRTD0QaoewCMh+RjN3qDMYm6eAlDJmVMJc0QjWy5hUClMhCGYIWikHonhF2NjYEUVAokkVTcWSjYLoAqjBA3QoqoCQKaqZDIKGjmghaOGJJqAcIogSzIzCLTMEjZEVCVl4CqEICDYbuVogCzAKChs3opgrZGyE6nhB9LiEAADY3CNCx3CX8AAAAABJRU5ErkJggg==',
  'old_god': 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAMAAABEpIrGAAAAMFBMVEX////yynX7vTaXZBeugiHu7u7CuLiilZWQcFy9pZGjhHFZTU19SyWEWTqQVBGARwxRuE8NAAAAAXRSTlMAQObYZgAAAIdJREFUOI3V0NsOhDAIBNB6AXRw1///W2ttTarCmn0rT5PMSUMJoZnp+qHE8REQS05nuILpCHMB/S8AE+QArQHksgykEsS81E9B6m2JMbmgiAJwA1kQf4w+i+MF4PFeUQizsBp9+ksCavT7mRIw+zh7qU4fKLbq9HENt34FvAVaAd139cEfswGXkwSFo0l9RgAAAABJRU5ErkJggg==',
  'ravox': 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgBAMAAACBVGfHAAAAJFBMVEX////1tABxbGVKPzdhTSGDg0FKKhIaDwwFAwNcVUwxIx3DvZ6mto0ZAAAAAXRSTlMAQObYZgAAAKVJREFUKJHNzqEOwjAQBuD2DXYVsEwWNbkgIOd5A4JHkeCqip1baothjiAa6nk/rglprwg0v+uX/64nxP9EwicZ9DDsDqfWFLjha2/DyOC6OJ4ZqH4GcDaDUL1vZLwAgzlBkwE0gbMFpPYAvEFwb6NhoAhCvitt9XEqZ1C61dZ9AcYK4IH8Ltr6RP4rQcQwVdCtw8hBJOBv2rqBCuTSVBNUqQu/8ganrSu7FMLt1AAAAABJRU5ErkJggg==',
  'undivided': 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgBAMAAACBVGfHAAAAElBMVEX////t/6R4Qh2shDHhxWJCChO9RIJXAAAAAXRSTlMAQObYZgAAAHd6VFh0RGVzY3JpcHRpb24AAHicU1ZwcnX39FNw8fXkKkstKs7Mz1OwVTDRM+DiLM9MKckAcoyNuDgzUjPTM0ognOKSxJJUIFOpODM9Lz40LyWzLDMlNUWJizMls6gYKGHIxZlWlJibCmXn5OcXgFnKCq5+LmCbAKPLIDIkYIoNAAAAeklEQVQokc3Qyw0CMQxF0WcpBeSZBohxAZDR7BHQQPj03wrsxp7FIHZ4eXQtOQH+aoTMwNZqCrQZc8ApJqK7k/WQ0Kqgh0R5FBx6gIoCbMJtX9IK7VwwjwVEL25zvIx+nUa8XdRf+XX0FHwSH8jw/B0eX+G+hvWvL/MGYgcOBheagREAAAAASUVORK5CYII=',
  'xylix': 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAMAAABEpIrGAAABZVBMVEX////1tAAAAAA0NDQ8PDy/v7+8vLyampp4eHhwcHBEREQwMDAyMjJTU1NkZGSCgoKoqKjBwcHOzs67u7s5OTnJycnKysrNzc3FxcXCwsK2tracnJxzc3MNDQ2IiIhiYmKOjo7T09PU1NRubm5OTk4jIyOenp5HR0dISEi5ubleXl6MjIxMTExXV1eWlpZ9fX20tLQpKSkqKiocHBwUFBRoaGhsbGyTk5MsLCwDAwMEBAQLCwsfHx8aGhqvr68nJyfW1tbGxsY6OjolJSWkpKSrq6vQ0NBQUFAODg7x8fH39/f09PTb29thYWGhoaE+Pj4XFxd+fn74+Pjy8vLq6urY2NgRERFcXFw3NzcSEhKmpqZAQED+/v6srKwuLi4GBgaRkZGwsLBbW1uKioogICAYGBh0dHSGhoZ2dnaysrJKSkrm5ub6+vrj4+Pf39/8/Pzu7u6YmJhnZ2eioqLg4ODc3NyBgYEtlZaUAAAAAXRSTlMAQObYZgAAAnZJREFUOI2tk2lb2kAQgM0E0AY82LibBAXZeFQUOYMXEYjQVZBarAVB1IIE691W2/7+hrRaFT92vu3Mu88zO/PuwMB/CK4vXtaBhyfB8y8IDhxO1+DQG8HtGR4ZHfMiEV4C45hIWFZ8EwqWnJNY9vcBJDAV9FLqVOn0zOyc0ge8nZsXxdDCohqeFEVxififN8yBEImKLpcvhGIA8fiTfq2DDSScYlLTUiEyC/HlFWEVYG0d0slVPjzK24AemttIJPQMgSzOqapKCTYIolRVfZtcbwx513KkUAi8Az1FVCuNKGKMqIxR75YFwLaAi6WdMpIh8d5KY4x36QqSJEmloQ8WUPHsfSztf6oiqQYHmOG9egZTpbExf4hYwG0ByWbsqJTDhoQ0GEbhhYgiyGxPOZ7it/CJ9Qou7shgORVkGfi8JAd8oVZYwKw9M6FE2Uq9B4D7lEqVFmHgn8Qds6tpZ8SpaxUzGok5wH6FVqDTea0C+S/yYNOTEFHOe57I5vUL56U9KA6yocxBRUueOsuSbBgqQ8zABs6Rs3F78xys1o1jMzukXF1f3xCJ7hzdMlT8+o0cprm/xsCi0ZpdUMol6kTU+N5BVDFur8juOvfg1JLXWpQQoxLKVRqN2jKjhLJ27UEdjus6EA/JLUTP/bqum9t1a9qStUvu0YnNqTq4o3SstmH2iPSdOg//6hYAifs0CNWU36xVuskGn1PXntR75tuGxO75Hz/V8qD7kp3Cc7ltvUaoy7cYDAbaIgpuvnDbhpqdwj2qVknr8ELr+z89oHuHS8X9/WK143nlfq/V5i96c1WstgV45f6fkSZM8wTg9fqzb/yY+w3R8GkUH6YiVAAAAABJRU5ErkJggg==',
  'zizo': 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgBAMAAACBVGfHAAAAFVBMVEX///+2AAB6GCJTIiIqICkqEh0VEBFHJGzoAAAAAXRSTlMAQObYZgAAAItJREFUKJG90cENgzAMBdB4g5g4A1DRAShZwAF6d+kCiP13aHMJsbn0VF8sPX1bjuLcPwvRQNcbCBcY7cgF2ILYHRZsAjrxGvJq4JU04Dbrx8Qpq0MgDHlsZ/B2rAnbwP3gjc8IPCQwNREckCTONQKBPQnSVCHtjvbvLRWeWACWCm/vogL05RtK+6U+2LwQ/m2bzxwAAAAASUVORK5CYII=',
};

const GOD_TOOLTIPS: Record<string, string> = {
  'abyssor': 'Абиссор благословляет водоемы поблизости от вашего имения, наполняя их косяками рыб.',
  'astrata': 'Для поддержания Её закона, на ваших землях возведён аванпост, который периодически отправляет войска для борьбы с бандитизмом.',
  'baotha': 'Следуя учениям Баоты, ваши крестьяне ведут гедонический образ жизни. В определенные дни недели они отводят время для отдыха и развлечений, что повышает их продуктивность в другие периоды.',
  'dendor': 'Дендор благословляет леса поблизости от вашего имения, привлекая дичь на ваши угодья. Ваши охотники не забывают соблюдать все необходимые обряды и возносить Ему хвалу.',
  'eora': '',
  'graggar': 'Ваши солдаты регулярно выходят в рейды, чтобы захватить новых рабов для вашего имения.',
  'malum': 'Малум благословляет холмы и горы поблизости от вашего имения. Шахты изобилуют рудами и драгоценностями.',
  'matthios': 'Жители вашего имения - не слуги, но товарищи в борьбе за свободу. Они не платят налога ни казне, ни вам, вместо этого добровольно поддерживая вас финансами. Часть сырья и товаров укрывается от казны и продается на рынке, благодаря чему вы избегаете налогообложения.',
  'necra': '',
  'noc': 'Рабочие вашего имения бодрствуют ночью и спят денем, поставляя плоды своего труда на рассвете. Ночная охота обильнее дневной, но уход за полями и садами становится сложнее.',
  'pestra': '',
  'old_god': 'Каждый Дае Солнца, ваши крестьяне возносят хвалу Всеотцу в церквушке, возведенной на ваших землях. Вдохновленные на свершения Его примером, они трудятся с высочайшей самоотдачей.',
  'ravox': 'Для поддержания Его порядка, на ваших землях возведён аванпост, который периодически отправляет войска для борьбы с бандитизмом.',
  'undivided': '',
  'xylix': 'Торговцы часто прибывают к вашему имению, и прибыль от сделок течет рекой. Возможно, в этом замешана благосклонность Ксайликса.',
  'zizo': 'Благодаря Её благословению, рабочие вашего имения не знают усталости, поставляя плоды своего труда дважды в день, на закате и на рассвете. Торговля со смертными требует маскировки, что значительно снижает её эффективность.',
};


const HoverCard = ({ data }: { data: HoverCardData | null }) => {
  if (!data) {
    return null;
  }

  return (
    <Box
      style={{
        position: 'fixed',
        left: '50%',
        top: '72px',
        transform: 'translateX(-50%)',
        width: '720px',
        maxWidth: 'calc(100vw - 48px)',
        padding: '10px 12px',
        borderRadius: '8px',
        background: 'radial-gradient(circle at top, rgba(154,108,49,0.18), transparent 26%),' +
        'linear-gradient(180deg, rgba(24,14,8,1) 0%, rgba(14,9,5,1) 100%)',
        border: '1px solid rgba(226,191,141,0.08)',
        boxShadow: '0 8px 20px rgba(0,0,0,0.45)',
        zIndex: 1000,
        pointerEvents: 'none',
      }}>
      <Stack>
        <Stack.Item grow basis="55%">
          {!!data.text && (
            <Box mb={0.75} style={{ opacity: 0.9, lineHeight: 1.35, whiteSpace: 'pre-line' }}>
              {data.text}
            </Box>
          )}
        </Stack.Item>
      </Stack>
    </Box>
  );
};

type HoverCardData = {
  text: string;
};

const clamp = (value: number, min = 0, max = 100) => Math.max(min, Math.min(max, value));

const getKindTheme = (kind: string) => {
  switch (kind) {
    case 'field':
      return {
        accent: '#d7b065',
        border: 'transparent',
        card: 'transparent',
        overlay: 'transparent',
        chip: 'rgba(24, 14, 8, 0.33)',
        subtitle: 'Злаки и овощи',
      };
    case 'orchard':
      return {
        accent: '#8fc86d',
        border: 'transparent',
        card: 'transparent',
        overlay: 'transparent',
        chip: 'rgba(24, 14, 8, 0.33)',
        subtitle: 'Фрукты и ягоды',
      };
    case 'hunt':
      return {
        accent: '#88a8d8',
        border: 'transparent',
        card: 'transparent',
        overlay: 'transparent',
        chip: 'rgba(24, 14, 8, 0.33)',
        subtitle: 'Мех, шкуры и дичь',
      };
    case 'farm':
      return {
        accent: '#d4ae71',
        border: 'transparent',
        card: 'transparent',
        overlay: 'transparent',
        chip: 'rgba(24, 14, 8, 0.33)',
        subtitle: 'Скот и припасы',
      };
    case 'trade':
      return {
        accent: '#c7a2e5',
        border: 'transparent',
        card: 'transparent',
        overlay: 'transparent',
        chip: 'rgba(24, 14, 8, 0.33)',
        subtitle: 'Товары и прибыль',
      };
    case 'fish':
      return {
        accent: '#a2bfe5',
        border: 'transparent',
        card: 'transparent',
        overlay: 'transparent',
        chip: 'rgba(24, 14, 8, 0.33)',
        subtitle: 'Рыба и морские сокровища',
      };
    case 'mining':
      return {
        accent: '#e5a2a2',
        border: 'transparent',
        card: 'transparent',
        overlay: 'transparent',
        chip: 'rgba(24, 14, 8, 0.33)',
        subtitle: 'Руды и ископаемые',
      };
    case 'forest':
      return {
        accent: '#a2e5a7',
        border: 'transparent',
        card: 'transparent',
        overlay: 'transparent',
        chip: 'rgba(24, 14, 8, 0.33)',
        subtitle: 'Древисина и уголь',
      };
    case 'mage_tower':
      return {
        accent: '#d5a2e5',
        border: 'transparent',
        card: 'transparent',
        overlay: 'transparent',
        chip: 'rgba(24, 14, 8, 0.33)',
        subtitle: 'Магические реагенты',
      };
    case 'cathedral':
      return {
        accent: '#fafafa',
        border: 'transparent',
        card: 'transparent',
        overlay: 'transparent',
        chip: 'rgba(24, 14, 8, 0.33)',
        subtitle: 'Вознесем хвалу Ему',
      };
    case 'outpost':
      return {
        accent: '#e5a2a2',
        border: 'transparent',
        card: 'transparent',
        overlay: 'transparent',
        chip: 'rgba(24, 14, 8, 0.33)',
        subtitle: 'На страже мира и порядка',
      };
    default:
      return {
        accent: '#d9c39a',
        border: 'rgba(238, 220, 185, 0.28)',
        card: 'linear-gradient(180deg, rgba(97,70,43,0.96), rgba(47,32,18,0.98))',
        overlay: 'linear-gradient(135deg, rgba(240,210,160,0.12), rgba(0,0,0,0.08) 70%)',
        chip: 'rgba(24, 14, 8, 0.33)',
        subtitle: 'Хозяйственное угодье',
      };
  }
};

const getManorType = (type: string) => {
  switch (type) {
    case 'manor':
      return 'Поместье';
    case 'hunter_mansion':
      return 'Охотничья усадьба';
    case 'fisher_hamlet':
      return 'Рыбацкий хутор';
    case 'mining_settlement':
      return 'Шахтерский поселок';
    case 'village':
      return 'Деревня';
    default:
      return 'Имение';
  }
};

const getProduceType = (type: string) => {
  switch (type) {
    case 'Goods':
      return 'Производит сырьё';
    case 'Profit':
      return 'Приносит прибыль';
    case 'Boost':
      return 'Повышает продуктивность';
    case 'Defense':
      return 'Противостоит бандитам';
    default:
      return 'Производит сырье';
  }
};

const panelBackground: React.CSSProperties = {
  background:
    'radial-gradient(circle at top, rgba(154,108,49,0.18), transparent 26%),' +
    'linear-gradient(180deg, rgba(24,14,8,1) 0%, rgba(14,9,5,1) 100%)',
  color: '#ead9bb',
};

const frameStyle: React.CSSProperties = {
  border: '1px solid rgba(224, 187, 128, 0.22)',
  borderRadius: '18px',
  boxShadow: '0 16px 34px rgba(0,0,0,0.35), inset 0 1px 0 rgba(255,255,255,0.04)',
  background: 'linear-gradient(180deg, rgba(49,30,15,0.94), rgba(27,17,9,0.98))',
  position: 'relative',
};

const ornamentBand: React.CSSProperties = {
  height: '8px',
  borderRadius: '999px',
  background:
    'repeating-linear-gradient(90deg, rgba(233,191,121,0.34) 0 14px, rgba(115,74,33,0.12) 14px 28px)',
};

const statBox = (label: string, value: number | string) => (
  <div
    style={{
      minWidth: '122px',
      padding: '10px 12px',
      borderRadius: '14px',
      border: '1px solid rgba(222, 184, 131, 0.22)',
      background: 'linear-gradient(180deg, rgba(93,58,28,0.28), rgba(27,17,9,0.42))',
      boxShadow: 'inset 0 1px 0 rgba(255,255,255,0.04)',
    }}>
    <div style={{ fontSize: '11px', textTransform: 'uppercase', letterSpacing: '0.12em', opacity: 0.72 }}>{label}</div>
    <div style={{ fontSize: '24px', fontWeight: 800, marginTop: '2px' }}>{value}</div>
  </div>
);

const resourceChip = (background: string): React.CSSProperties => ({
  display: 'inline-block',
  marginRight: '6px',
  marginBottom: '6px',
  padding: '4px 8px',
  borderRadius: '999px',
  fontSize: '11px',
  border: '1px solid rgba(255,255,255,0.08)',
  background,
  boxShadow: 'inset 0 1px 0 rgba(255,255,255,0.05)',
});

const workerButton: React.CSSProperties = {
  minWidth: '36px',
  height: '32px',
  borderRadius: '10px',
  border: '1px solid rgba(230, 191, 134, 0.25)',
  background: 'linear-gradient(180deg, rgba(107,71,34,0.9), rgba(59,37,16,0.95))',
  color: '#f0dfc0',
  fontSize: '20px',
  fontWeight: 700,
  boxShadow: '0 6px 14px rgba(0,0,0,0.22), inset 0 1px 0 rgba(255,255,255,0.05)',
};

const PatronMedallion = ({
  patronKey,
  setHoveredItem,
}: {
  patronKey: string;
  setHoveredItem: (value: HoverCardData | null) => void;
}) => {
  const icon = GOD_ICONS[patronKey] || GOD_ICONS.astrata;
  const godtooltip = GOD_TOOLTIPS[patronKey] || GOD_TOOLTIPS.astrata;
  return (
    <div style={{
      width: '104px',
      display: 'flex',
      alignItems: 'center',
      justifyContent: 'center',
    }}>
      <div style={{
        width: '92px',
        height: '92px',
        borderRadius: '50%',
        border: '1px solid rgba(255, 218, 156, 0.22)',
        background:
          'radial-gradient(circle at 50% 35%, rgba(255,231,171,0.2), rgba(99,23,28,0.92) 70%),' +
          'linear-gradient(180deg, rgba(93,32,35,0.98), rgba(47,11,15,1))',
        boxShadow: '0 12px 28px rgba(0,0,0,0.34), inset 0 1px 0 rgba(255,255,255,0.05)',
        display: 'flex',
        alignItems: 'center',
        justifyContent: 'center',
      }}
      onMouseEnter={() =>
        setHoveredItem({
          text: godtooltip,
        })
      }
      onMouseLeave={() => setHoveredItem(null)}>
        <img
          src={icon}
          style={{
            width: '56px',
            height: '56px',
            imageRendering: 'pixelated',
            filter: 'drop-shadow(0 4px 10px rgba(0,0,0,0.52))',
          }}
        />
      </div>
    </div>
  );
};

const Scene = ({ kind }: { kind: string }) => {
  const common: React.CSSProperties = { position: 'absolute', pointerEvents: 'none' };

  if (kind === 'field') {
    return (
      <>
        <div style={{ ...common, left: '0', right: '0', bottom: '0', width: '100%', height: '100%' }}><img src={resolveAsset('field_icon.png')} alt="Поля" style={{width: '100%', height: '100%', objectFit: 'fill', display: 'block', userSelect: 'none'}} /></div>
      </>
    );
  }

  if (kind === 'orchard') {
    return (
      <>
        <div style={{ ...common, left: '0', right: '0', bottom: '0', width: '100%', height: '100%' }}><img src={resolveAsset('fruit_icon.png')} alt="Сады" style={{width: '100%', height: '100%', objectFit: 'fill', display: 'block', userSelect: 'none'}} /></div>
      </>
    );
  }

  if (kind === 'hunt') {
    return (
      <>
        <div style={{ ...common, left: '0', right: '0', bottom: '0', width: '100%', height: '100%' }}><img src={resolveAsset('hunting_icon.png')} alt="Охотничьи угодья" style={{width: '100%', height: '100%', objectFit: 'fill', display: 'block', userSelect: 'none'}} /></div>
      </>
    );
  }

  if (kind === 'farm') {
    return (
      <>
        <div style={{ ...common, left: '0', right: '0', bottom: '0', width: '100%', height: '100%' }}><img src={resolveAsset('ranch_icon.png')} alt="Фермы" style={{width: '100%', height: '100%', objectFit: 'fill', display: 'block', userSelect: 'none'}} /></div>
      </>
    );
  }

  if (kind === 'trade') {
    return (
      <>
        <div style={{ ...common, left: '0', right: '0', bottom: '0', width: '100%', height: '100%' }}><img src={resolveAsset('trade_icon.png')} alt="Торговые ряды" style={{width: '100%', height: '100%', objectFit: 'fill', display: 'block', userSelect: 'none'}} /></div>
      </>
    );
  }

  if (kind === 'fish') {
    return (
      <>
        <div style={{ ...common, left: '0', right: '0', bottom: '0', width: '100%', height: '100%' }}><img src={resolveAsset('fishing_icon.png')} alt="Заводи" style={{width: '100%', height: '100%', objectFit: 'fill', display: 'block', userSelect: 'none'}} /></div>
      </>
    );
  }

  if (kind === 'mining') {
    return (
      <>
        <div style={{ ...common, left: '0', right: '0', bottom: '0', width: '100%', height: '100%' }}><img src={resolveAsset('mine_icon.png')} alt="Шахты" style={{width: '100%', height: '100%', objectFit: 'fill', display: 'block', userSelect: 'none'}} /></div>
      </>
    );
  }

  if (kind === 'forest') {
    return (
      <>
        <div style={{ ...common, left: '0', right: '0', bottom: '0', width: '100%', height: '100%' }}><img src={resolveAsset('forest_icon.png')} alt="Леса" style={{width: '100%', height: '100%', objectFit: 'fill', display: 'block', userSelect: 'none'}} /></div>
      </>
    );
  }

  if (kind === 'mage_tower') {
    return (
      <>
        <div style={{ ...common, left: '0', right: '0', bottom: '0', width: '100%', height: '100%' }}><img src={resolveAsset('mage_tower_icon.png')} alt="Леса" style={{width: '100%', height: '100%', objectFit: 'fill', display: 'block', userSelect: 'none'}} /></div>
      </>
    );
  }

  if (kind === 'cathedral') {
    return (
      <>
        <div style={{ ...common, left: '0', right: '0', bottom: '0', width: '100%', height: '100%' }}><img src={resolveAsset('cathedral_icon.png')} alt="Леса" style={{width: '100%', height: '100%', objectFit: 'fill', display: 'block', userSelect: 'none'}} /></div>
      </>
    );
  }

  if (kind === 'outpost') {
    return (
      <>
        <div style={{ ...common, left: '0', right: '0', bottom: '0', width: '100%', height: '100%' }}><img src={resolveAsset('outpost_icon.png')} alt="Аванпост" style={{width: '100%', height: '100%', objectFit: 'fill', display: 'block', userSelect: 'none'}} /></div>
      </>
    );
  }

  return null;
};

const WorkstationCard = ({ ws, act }: { ws: WorkstationData; act: (action: string, payload?: object) => void }) => {
  const theme = getKindTheme(ws.kind);
  const percent = ws.workers_max ? clamp((ws.workers_employed / ws.workers_max) * 100) : 0;

  return (
    <div
      style={{
        position: 'relative',
        overflow: 'hidden',
        minHeight: '214px',
        padding: '14px',
        borderRadius: '16px',
        background: `${theme.overlay}, ${theme.card}`,
        border: `1px solid ${theme.border}`,
        boxShadow: '0 14px 24px rgba(0,0,0,0.22), inset 0 1px 0 rgba(255,255,255,0.05)',
        textShadow: '-1px -1px 3px black, 1px -1px 2px black, -1px 1px 2px black, 1px 1px 2px black',
      }}>
      <Scene kind={ws.kind} />
      <div style={{ position: 'relative', zIndex: 1 }}>
        <div style={{ display: 'flex', justifyContent: 'space-between', gap: '10px' }}>
          <div>
            <div style={{ fontSize: '25px', fontWeight: 800, lineHeight: 1.1, color: theme.accent, textShadow: '-1px -1px 2px black, 1px -1px 0 black, -1px 1px 0 black, 1px 1px 0 black' }}>{ws.name}</div>
            <div style={{ fontSize: '15px', marginTop: '5px', letterSpacing: '0.12em', textTransform: 'uppercase' }}>{theme.subtitle}</div>
          </div>
          <div style={{ textAlign: 'right' }}>
            <div style={{ fontSize: '23px', fontWeight: 800, color: theme.accent, textShadow: '-1px -1px 2px black, 1px -1px 0 black, -1px 1px 0 black, 1px 1px 0 black' }}>{ws.workers_employed}/{ws.workers_max}</div>
            <div style={{ fontSize: '15px' }}>рабочих</div>
          </div>
        </div>

        <div style={{ marginTop: '12px' }}>
          <div style={{
            height: '10px',
            borderRadius: '999px',
            overflow: 'hidden',
            background: 'rgba(0,0,0,0.28)',
            border: '1px solid rgba(255,255,255,0.06)',
          }}>
            <div style={{
              width: `${percent}%`,
              height: '100%',
              background: `linear-gradient(90deg, ${theme.accent}, rgba(255,255,255,0.82))`,
              boxShadow: '0 0 16px rgba(255,255,255,0.16)',
            }} />
          </div>
          <div style={{ marginTop: '6px', fontSize: '15px', display: 'flex', justifyContent: 'space-between' }}>
            <span>Заполненность угодья</span>
            <span>{Math.round(percent)}%</span>
          </div>
        </div>

        <div style={{ marginTop: '12px', minHeight: '58px' }}>
          {ws.produce.slice(0, 10).map((item) => (
            <span key={item} style={resourceChip(theme.chip)}>{item}</span>
          ))}
        </div>

        <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'flex-end', gap: '10px', marginTop: '8px' }}>
          <div style={{ display: 'flex', gap: '8px' }}>
            <Button style={workerButton} onClick={() => act('dec_workers', { id: ws.id })}>−</Button>
            <Button style={workerButton} onClick={() => act('inc_workers', { id: ws.id })}>+</Button>
          </div>
          <div style={{ textAlign: 'right', fontSize: '15px' }}>
            <div>Продуктивность: {Math.round(ws.production_bonus * 100)}%</div>
            <div>{getProduceType(ws.type_of_produce)}</div>
          </div>
        </div>
      </div>
    </div>
  );
};

export const ManorPanel = () => {
  const { act, data } = useBackend<ManorPanelData>();
  const [hoveredItem, setHoveredItem] = useState<HoverCardData | null>(null);
  const {
    manor_name,
    manor_type,
    manor_patron_key,
    manor_origin,
    total_workers,
    workers_assigned,
    workers_free,
    productivity_last_cycle,
    workstations = [],
  } = data;

  const loadPercent = total_workers ? clamp((workers_assigned / total_workers) * 100) : 0;

  return (
    <Window title={manor_name || 'Владение'} width={860} height={595}>
      <Window.Content scrollable style={panelBackground}>
        <div style={{ padding: '12px' }}>
          <div style={{ ...frameStyle, padding: '14px 16px 12px' }}>
            <div style={{ position: 'absolute', inset: '12px', border: '1px solid rgba(226,191,141,0.08)', borderRadius: '14px', pointerEvents: 'none' }} />
            <div style={{ ...ornamentBand, marginBottom: '12px' }} />
            <div style={{ display: 'grid', gridTemplateColumns: '1fr 108px', gap: '14px', alignItems: 'center' }}>
              <div>
                <div style={{ display: 'flex', alignItems: 'center', gap: '12px' }}>
                  <div style={{ flex: 1 }}>
                    <div style={{ fontSize: '29px', fontWeight: 900, lineHeight: 1.02 }}>{manor_name}</div>
                    <div style={{ marginTop: '6px', fontSize: '11px', letterSpacing: '0.16em', textTransform: 'uppercase', opacity: 0.72 }}>
                      {getManorType(manor_type)}
                    </div>
                    {manor_origin ? (
                      <div style={{ marginTop: '6px', fontSize: '11px', letterSpacing: '0.16em', textTransform: 'uppercase', opacity: 0.72 }}>
                        {manor_origin}
                      </div>
                    ) : ('')}
                  </div>
                </div>

                <div style={{ marginTop: '12px', display: 'flex', gap: '10px', flexWrap: 'wrap' }}>
                  {statBox('Всего', total_workers)}
                  {statBox('Занято', workers_assigned)}
                  {statBox('Свободно', workers_free)}
                  {statBox('За цикл', productivity_last_cycle)}
                </div>

                <div style={{
                  marginTop: '14px',
                  padding: '10px 12px 11px',
                  borderRadius: '14px',
                  border: '1px solid rgba(228,190,139,0.14)',
                  background: 'linear-gradient(180deg, rgba(94,58,28,0.24), rgba(24,14,8,0.4))',
                  boxShadow: 'inset 0 1px 0 rgba(255,255,255,0.04)',
                }}>
                  <div style={{ display: 'flex', justifyContent: 'space-between', fontSize: '11px', letterSpacing: '0.12em', textTransform: 'uppercase', opacity: 0.8 }}>
                    <span>Занятость людей</span>
                    <span>{Math.round(loadPercent)}%</span>
                  </div>
                  <div style={{
                    marginTop: '8px',
                    height: '12px',
                    borderRadius: '999px',
                    overflow: 'hidden',
                    border: '1px solid rgba(245, 208, 149, 0.12)',
                    background: 'rgba(0,0,0,0.3)',
                  }}>
                    <div style={{
                      width: `${loadPercent}%`,
                      height: '100%',
                      background: 'linear-gradient(90deg, rgba(177,124,47,0.95), rgba(245,214,161,0.96))',
                      boxShadow: '0 0 20px rgba(255,228,179,0.14)',
                    }} />
                  </div>
                </div>
              </div>

              <PatronMedallion patronKey={manor_patron_key} setHoveredItem={setHoveredItem} />
            </div>
          </div>

          <div style={{ marginTop: '12px', padding: '0 4px' }}>
            <div style={{ ...ornamentBand, marginBottom: '9px' }} />
            <div style={{
              display: 'flex',
              alignItems: 'center',
              justifyContent: 'space-between',
              gap: '8px',
              flexWrap: 'wrap',
            }}>
              <div style={{ fontSize: '21px', fontWeight: 900, letterSpacing: '0.08em', textTransform: 'uppercase' }}>Угодья</div>
              <div style={{ fontSize: '11px', opacity: 0.72, letterSpacing: '0.12em', textTransform: 'uppercase' }}>
                Управление рабочими местами
              </div>
            </div>
          </div>

          {workstations.length ? (
            <div style={{
              display: 'grid',
              gridTemplateColumns: '1fr 1fr',
              gap: '12px',
              marginTop: '10px',
            }}>
              {workstations.slice(0, 5).map((ws) => (
                <WorkstationCard key={ws.id} ws={ws} act={act} />
              ))}
            </div>
          ) : (
            <div style={{
              ...frameStyle,
              marginTop: '10px',
              padding: '14px',
              textAlign: 'center',
              fontSize: '14px',
              opacity: 0.85,
            }}>
              У этого персонажа пока нет доступного поместья или в нём ещё не создано ни одного угодья.
            </div>
          )}
        </div>
        <HoverCard data={hoveredItem} />
      </Window.Content>
    </Window>
  );
};
