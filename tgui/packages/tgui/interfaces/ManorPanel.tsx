import type React from 'react';
import {
  Box,
  Button,
  Icon,
  Input,
  NumberInput,
  Stack,
  Tabs,
} from 'tgui-core/components';
import { useBackend } from '../backend';
import { Window } from '../layouts';
import { resolveAsset } from '../assets';
import { useEffect, useMemo, useRef, useState } from 'react';
import type {
  ManorIndustryData,
  ManorPanelData,
  WarehouseItem,
  WorkstationData,
} from './ManorPanelData';

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
  'graggar': 'В ваших землях чтут Граггара. Силу и стойкость здесь ставят выше милосердия.',
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

const getManorType = (type: string) => {
  switch (type) {
    case 'manor':
      return 'Поместье';
    case 'hunter_mansion':
      return 'Охотничья усадьба';
    case 'fisher_hamlet':
      return 'Рыбацкий хутор';
    case 'mining_settlement':
      return 'Шахтёрский посёлок';
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

const PatronMedallion = ({
  patronKey,
  setHoveredItem,
}: {
  patronKey: string;
  setHoveredItem: (value: HoverCardData | null) => void;
}) => {
  const icon = GOD_ICONS[patronKey] || GOD_ICONS.astrata;
  const godtooltip = GOD_TOOLTIPS[patronKey] || '';
  return (
    <div
      style={{
        width: '48px',
        height: '48px',
        flexShrink: 0,
        borderRadius: '50%',
        border: '1px solid rgba(255, 218, 156, 0.22)',
        background: 'radial-gradient(circle at 50% 35%, #96383d, #5e181c 78%)',
        display: 'grid',
        placeItems: 'center',
      }}
      onMouseEnter={() => setHoveredItem(godtooltip ? { text: godtooltip } : null)}
      onMouseLeave={() => setHoveredItem(null)}>
      <img
        src={icon}
        alt=""
        style={{ width: '30px', height: '30px', imageRendering: 'pixelated' }}
      />
    </div>
  );
};

const workstationImages: Partial<Record<string, string>> = {
  cathedral: 'cathedral_icon.png',
  farm: 'ranch_icon.png',
  field: 'field_icon.png',
  fish: 'fishing_icon.png',
  forest: 'forest_icon.png',
  hunt: 'hunting_icon.png',
  mage_tower: 'mage_tower_icon.png',
  mining: 'mine_icon.png',
  orchard: 'fruit_icon.png',
  outpost: 'outpost_icon.png',
  trade: 'trade_icon.png',
};

const tableBorder = '1px solid rgba(226,191,141,0.14)';
const tablePanel: React.CSSProperties = {
  ...frameStyle,
  marginTop: '12px',
  padding: '12px 16px',
};

const workstationAccents: Partial<Record<string, string>> = {
  cathedral: '#e1d7b5',
  farm: '#d4ae71',
  field: '#d7b065',
  fish: '#a2bfe5',
  forest: '#a2d5a7',
  forge: '#d9b784',
  hunt: '#a1bbd7',
  mage_tower: '#d5a2e5',
  mining: '#e5b0a2',
  orchard: '#a8cb82',
  outpost: '#e5a2a2',
  smeltery: '#dfab75',
  trade: '#c7a2e5',
};

const defaultIngotNames: Record<string, string> = { iron: 'Iron Ingot', steel: 'Steel Ingot' };
const productionPointsFormat = new Intl.NumberFormat('ru-RU', { maximumFractionDigits: 3 });
const sharedPointsHint = 'Очки от всех материалов поступают на общий счёт.';

const getMaterialName = (industry: ManorIndustryData, material: string) =>
  industry.metal_names?.[material] ?? defaultIngotNames[material] ?? material;

const productionTile = (accent: string, selected: boolean): React.CSSProperties => ({
  font: 'inherit',
  padding: '4px 8px',
  minHeight: '26px',
  color: selected ? '#f4e1c1' : '#ead9bb',
  border: `1px solid ${selected ? accent : 'rgba(234, 205, 160, 0.30)'}`,
  borderRadius: '5px',
  background: selected ? 'rgba(150, 103, 47, 0.68)' : 'rgba(43, 29, 18, 0.84)',
  cursor: 'pointer',
});

const ManorWorkstationCard = ({
  station,
  free,
  industry,
}: {
  station: WorkstationData;
  free: number;
  industry?: ManorIndustryData;
}) => {
  const { act, data } = useBackend<ManorPanelData>();
  const [inspected, setInspected] = useState<string | null>(null);
  const image = workstationImages[station.kind];
  const accent = workstationAccents[station.kind] ?? '#d9c39a';
  const isSmeltery = station.kind === 'smeltery';
  const isForge = station.kind === 'forge';
  const stage = industry?.stages?.find((item) => item.station_id === station.id);
  const stageOption = stage?.options.find((option) => option.id === stage.selected);
  const stageInputs = stageOption?.inputs?.join(' + ');
  const stageOutput =
    stage?.kind === 'workshop' && stageOption?.points_per_unit
      ? `${productionPointsFormat.format(stageOption.points_per_unit)} ОП`
      : stageOption?.produce.join(', ');
  const isIndustrial = isSmeltery || isForge || !!stage;
  const miningOptions = station.kind === 'mining' ? industry?.mining_options : undefined;
  const isPriorityMine = !!miningOptions?.length;
  const smelteryMetal = industry?.smeltery_metal;
  const forgeMetal = industry?.forge_metal;
  const metal = isSmeltery ? smelteryMetal : forgeMetal;
  const forgeRate = forgeMetal ? industry?.points_per_ingot?.[forgeMetal] : undefined;
  const materialOptions = (isSmeltery ? industry?.smeltery_options : industry?.forge_options)
    ?? industry?.metal_options;
  const warehouseGood = inspected && data.warehouse?.find((item) => item.name === inspected);
  const separateForgeStock = isForge && industry && forgeMetal && forgeMetal !== smelteryMetal
    ? getMaterialName(industry, forgeMetal)
    : null;

  return (
    <section
      aria-label={station.name}
      style={{
        ...frameStyle,
        borderColor: 'rgba(226,191,141,0.36)',
        display: 'flex',
        flexDirection: 'column',
        overflow: 'hidden',
        minHeight: '164px',
        padding: '10px 12px',
      }}>
      {image && (
        <img
          src={resolveAsset(image)}
          alt=""
          style={{
            position: 'absolute',
            inset: 0,
            width: '100%',
            height: '100%',
            objectFit: 'cover',
            opacity: 0.44,
            pointerEvents: 'none',
          }}
        />
      )}
      <div
        style={{
          position: 'relative',
          display: 'flex',
          flexDirection: 'column',
          flexGrow: 1,
          gap: '6px',
        }}>
        <Stack align="center" justify="space-between">
          <Stack.Item>
            <Box bold color={accent} fontSize={1.45}>{station.name}</Box>
            {isPriorityMine ? (
              <div title="Приоритет повышает долю выбранного ресурса в общей добыче.">
                Приоритет добычи
              </div>
            ) : (
              <Box color="#ead9bb">
                {stage?.kind === 'processing' && 'Переработка сырья'}
                {stage?.kind === 'workshop' && 'Материал для мастерской'}
                {!stage && (isSmeltery ? 'Выплавка слитков' : isForge ? 'Сырьё для кузницы' : getProduceType(station.type_of_produce))}
              </Box>
            )}
          </Stack.Item>
          {isIndustrial && (
            <Stack.Item>
              <div
                aria-hidden="true"
                style={{
                  display: 'flex',
                  alignItems: 'center',
                  justifyContent: 'center',
                  width: '44px',
                  height: '38px',
                }}>
                {station.icon ? (
                  <span className={station.icon} style={{ imageRendering: 'pixelated', flexShrink: 0, transform: 'scale(1.2)' }} />
                ) : (
                  <Icon name={isForge || stage?.kind === 'workshop' ? 'hammer' : 'fire'} size={1.5} color={accent} />
                )}
              </div>
            </Stack.Item>
          )}
        </Stack>
        <div style={{ display: 'flex', flexWrap: 'wrap', gap: '4px' }}>
          {isPriorityMine && [
            { id: null, name: 'Без приоритета' },
            ...miningOptions,
          ].map((option) => {
            const selected = (industry?.mining_priority ?? null) === option.id;
            return (
              <button
                key={option.id ?? 'no-priority'}
                type="button"
                aria-pressed={selected}
                style={productionTile(accent, selected)}
                onClick={() => act('set_mining_priority', { good_id: option.id })}>
                {option.name}
              </button>
            );
          })}
          {stage?.options.map((option) => (
            <button
              key={option.id}
              type="button"
              aria-pressed={stage.selected === option.id}
              style={productionTile(accent, stage.selected === option.id)}
              onClick={() =>
                act('set_production_material', { stage: stage.id, material: option.id })
              }>
              {option.name}
            </button>
          ))}
          {!stage && industry && (isSmeltery || isForge) && materialOptions?.map((option) => (
            <button
              key={option}
              type="button"
              aria-pressed={metal === option}
              style={productionTile(accent, metal === option)}
              onClick={() => act('set_industry_metal', { station: station.kind, metal: option })}>
              {getMaterialName(industry, option)}
            </button>
          ))}
          {!isPriorityMine && !stage && (!industry || !isIndustrial) && station.produce?.map((product) => (
            <button
              key={product}
              type="button"
              aria-pressed={inspected === product}
              style={productionTile(accent, inspected === product)}
              onClick={() => setInspected(inspected === product ? null : product)}>
              {product}
            </button>
          ))}
        </div>
        {stageInputs && stageOutput && (
          <div style={{ color: '#ead9bb' }} title={stage?.kind === 'workshop' ? sharedPointsHint : undefined}>
            {stageInputs} → {stageOutput}
          </div>
        )}
        {!stage && isForge && industry && forgeMetal && forgeRate != null && (
          <div style={{ color: '#ead9bb' }} title={sharedPointsHint}>
            1 {getMaterialName(industry, forgeMetal)} → {productionPointsFormat.format(forgeRate)} ОП
          </div>
        )}
        {separateForgeStock && (
          <Box color="#ead9bb">
            На складе {data.warehouse?.find((item) => item.name === separateForgeStock)?.quantity ?? 0}
          </Box>
        )}
        {inspected && (
          <Box color="#ead9bb" aria-live="polite">
            {inspected}{station.type_of_produce === 'Goods'
              ? ` · На складе ${warehouseGood ? warehouseGood.quantity : 0}`
              : ` · ${getProduceType(station.type_of_produce)}`}
          </Box>
        )}
        <div
          style={{
            alignItems: 'center',
            borderTop: tableBorder,
            display: 'flex',
            gap: '8px',
            marginTop: 'auto',
            paddingTop: '5px',
          }}>
          <span>Работники</span>
          <Button
            icon="minus"
            tooltip={`Снять работника (${station.name})`}
            disabled={station.workers_employed <= 0}
            onClick={() => act('dec_workers', { id: station.id })}
          />
          <span style={{ fontVariantNumeric: 'tabular-nums', whiteSpace: 'nowrap' }}>
            {station.workers_employed}/{station.workers_max}
          </span>
          <Button
            icon="plus"
            tooltip={`Назначить работника (${station.name})`}
            disabled={station.workers_employed >= station.workers_max || free <= 0}
            onClick={() => act('inc_workers', { id: station.id })}
          />
        </div>
      </div>
    </section>
  );
};

const ManorWorkstations = ({
  workstations,
  peasantsFree,
  artisansFree,
  industry,
}: {
  workstations: WorkstationData[];
  peasantsFree: number;
  artisansFree: number;
  industry?: ManorIndustryData;
}) => {
  if (!workstations.length) {
    return <div style={tablePanel}>В имении пока нет рабочих мест.</div>;
  }

  const lastProduction = industry?.last_production;
  const lastSmelteryMetal = industry?.last_smeltery_metal;
  const lastForgeMetal = industry?.last_forge_metal;

  return (
    <>
      <div
        style={{
          display: 'grid',
          gridTemplateColumns: 'repeat(auto-fit, minmax(min(100%, 232px), 1fr))',
          gap: '10px',
          marginTop: '12px',
        }}>
        {workstations.map((station) => (
          <ManorWorkstationCard
            key={station.id}
            station={station}
            free={station.pool === 'artisans' ? artisansFree : peasantsFree}
            industry={industry}
          />
        ))}
      </div>
      {!lastProduction && industry?.has_report && lastSmelteryMetal && lastForgeMetal && (
        <Stack mt={1} align="center" wrap>
          <Stack.Item bold>За прошлый даэ</Stack.Item>
          <Stack.Item ml={1}>Iron Ore {industry.last_ore}</Stack.Item>
          <Stack.Item ml={1}>{getMaterialName(industry, lastSmelteryMetal)} {industry.last_ingots}</Stack.Item>
          <Stack.Item ml={1}>
            Кузница {industry.last_forged_ingots} {getMaterialName(industry, lastForgeMetal)} → {productionPointsFormat.format(industry.last_points ?? 0)} ОП
          </Stack.Item>
        </Stack>
      )}
      {lastProduction && (lastProduction.processed_good || lastProduction.material) && (
        <Stack mt={1} align="center" wrap>
          <Stack.Item bold>За прошлый даэ</Stack.Item>
          {lastProduction.processed_good && (
            <Stack.Item ml={1}>{lastProduction.processed_good} {lastProduction.processed}</Stack.Item>
          )}
          {lastProduction.material && (
            <Stack.Item ml={1}>
              Мастерская {lastProduction.consumed} {lastProduction.material_name ?? lastProduction.material} → {productionPointsFormat.format(lastProduction.points)} ОП
            </Stack.Item>
          )}
        </Stack>
      )}
    </>
  );
};

type WorkshopRecipe = ManorIndustryData['recipes'][number];

const recipeSprite = (recipe: WorkshopRecipe) => (
  <span
    style={{
      display: 'flex',
      alignItems: 'center',
      justifyContent: 'center',
      width: '38px',
      height: '38px',
      flexShrink: 0,
      overflow: 'hidden',
    }}>
    <span
      className={recipe.icon}
      style={{
        display: 'block',
        flexShrink: 0,
        transform: recipe.icon?.includes('64x64') ? 'scale(0.56)' : undefined,
      }}
    />
  </span>
);

const recipeRow: React.CSSProperties = {
  alignItems: 'center',
  display: 'flex',
  gap: '8px',
  height: '44px',
  boxSizing: 'border-box',
  borderBottom: tableBorder,
};

const WORKSHOP_PAGE_SIZE = 8;

const ManorWorkshop = ({
  industry,
  active,
}: {
  industry: ManorIndustryData;
  active: boolean;
}) => {
  const { act, data } = useBackend<ManorPanelData>();
  const [choosing, setChoosing] = useState(false);
  const [category, setCategory] = useState<string | null>(null);
  const [material, setMaterial] = useState<string | null>(null);
  const [search, setSearch] = useState('');
  const [page, setPage] = useState(0);
  const [draft, setDraft] = useState<Record<string, number>>({});
  const recipes = industry.recipes ?? [];
  const categories = [...new Set(recipes.map((recipe) => recipe.category))];
  const inCategory = recipes.filter((recipe) => recipe.category === category);
  const materials = new Map(inCategory.map((recipe) => [recipe.material, recipe.material_label]));
  const query = search.trim().toLocaleLowerCase();
  const showCatalogue = !!material || !!query;
  const matchingRecipes = showCatalogue
    ? recipes.filter((recipe) =>
        (!category || recipe.category === category) &&
        (!material || recipe.material === material) &&
        recipe.name.toLocaleLowerCase().includes(query),
      )
    : [];
  const pageCount = Math.max(1, Math.ceil(matchingRecipes.length / WORKSHOP_PAGE_SIZE));
  const currentPage = Math.min(page, pageCount - 1);
  const displayedRecipes = matchingRecipes.slice(
    currentPage * WORKSHOP_PAGE_SIZE,
    (currentPage + 1) * WORKSHOP_PAGE_SIZE,
  );
  const selected = recipes.filter((recipe) => draft[recipe.id] > 0);
  const { points } = industry;
  let orderTotal = 0;
  let quantity = 0;
  for (const recipe of selected) {
    const count = draft[recipe.id];
    orderTotal += recipe.cost * count;
    quantity += count * (recipe.units ?? 1);
  }

  if (!active) {
    return null;
  }

  return (
    <div style={tablePanel}>
      <Stack align="center" justify="space-between">
        <Stack.Item>
          <strong title={sharedPointsHint}>Очки производства {points}</strong>
        </Stack.Item>
        <Stack.Item>
          <Button
            icon={choosing ? 'times' : 'plus'}
            disabled={!recipes.length}
            onClick={() => {
              setChoosing(!choosing);
              setCategory(null);
              setMaterial(null);
              setSearch('');
              setPage(0);
            }}>
            {choosing ? 'Закрыть' : 'Добавить'}
          </Button>
        </Stack.Item>
      </Stack>

      {choosing && (
        <div style={{ borderTop: tableBorder, marginTop: '10px', paddingTop: '8px' }}>
          <Stack align="center" mb={1}>
            {category && (
              <Stack.Item>
                <Button
                  icon="arrow-left"
                  onClick={() => {
                    setPage(0);
                    if (material) {
                      setMaterial(null);
                    } else {
                      setCategory(null);
                    }
                  }}>
                  Назад
                </Button>
              </Stack.Item>
            )}
            <Stack.Item bold>
              {(material && materials.get(material)) || category || (query ? 'Каталог' : 'Категория')}
            </Stack.Item>
            <Stack.Item grow />
            <Stack.Item basis="14em">
              <Input
                fluid
                placeholder="Найти изделие"
                value={search}
                onChange={(value) => {
                  setSearch(value);
                  setPage(0);
                }}
              />
            </Stack.Item>
          </Stack>
          {!showCatalogue && !category && categories.map((value) => (
            <Button
              key={value}
              onClick={() => {
                setCategory(value);
                setPage(0);
              }}>
              {value}
            </Button>
          ))}
          {!showCatalogue && category && Array.from(materials, ([id, label]) => (
            <Button
              key={id}
              onClick={() => {
                setMaterial(id);
                setPage(0);
              }}>
              {label}
            </Button>
          ))}
          {showCatalogue && !displayedRecipes.length && <Box color="#ceb38b">Ничего не найдено.</Box>}
          {displayedRecipes.map((recipe) => (
            <div key={recipe.id} style={recipeRow}>
              {recipeSprite(recipe)}
              <Button
                fluid
                disabled={
                  !recipe.available ||
                  orderTotal + recipe.cost > points ||
                  quantity + (recipe.units ?? 1) > data.warehouse_shipment_limit
                }
                onClick={() =>
                  setDraft((items) => ({ ...items, [recipe.id]: (items[recipe.id] ?? 0) + 1 }))
                }
                style={{ textAlign: 'left', flex: '1 1 auto' }}>
                {recipe.name}
                {recipe.units != null && (recipe.units > 1 || recipe.category === 'Напитки') &&
                  ` ×${recipe.units}`}
                {' '}({recipe.cost} ОП)
              </Button>
              {recipe.locked && <Box color="#ceb38b">Требуется освоить материал</Box>}
            </div>
          ))}
          {pageCount > 1 && (
            <Stack align="center" justify="space-between" mt={1}>
              <Stack.Item>
                <Button
                  icon="chevron-left"
                  disabled={currentPage === 0}
                  onClick={() => setPage(currentPage - 1)}>
                  Предыдущая
                </Button>
              </Stack.Item>
              <Stack.Item>{currentPage + 1} / {pageCount}</Stack.Item>
              <Stack.Item>
                <Button
                  icon="chevron-right"
                  disabled={currentPage + 1 === pageCount}
                  onClick={() => setPage(currentPage + 1)}>
                  Следующая
                </Button>
              </Stack.Item>
            </Stack>
          )}
        </div>
      )}

      {selected.length > 0 && (
        <div style={{ borderTop: tableBorder, marginTop: '10px', paddingTop: '8px' }}>
          <Box bold>Заказ</Box>
          {selected.map((recipe) => {
            const batches = draft[recipe.id];
            const batchSize = recipe.units ?? 1;
            return (
              <div key={recipe.id} style={recipeRow}>
                {recipeSprite(recipe)}
                <span style={{ flexGrow: 1 }}>
                  {recipe.name} ×{batches}
                  {batchSize > 1 && ` (${batches * batchSize} шт.)`}
                </span>
                <span>{recipe.cost * batches} ОП</span>
                <Button
                  icon="minus"
                  tooltip={`${batchSize > 1 ? 'Убрать одну партию' : 'Убрать один предмет'} (${recipe.name})`}
                  onClick={() =>
                    setDraft((items) => ({ ...items, [recipe.id]: items[recipe.id] - 1 }))
                  }
                />
              </div>
            );
          })}
          <Stack mt={1} align="center" justify="space-between">
            <Stack.Item>
              <Box bold>Стоимость заказа {orderTotal} ОП</Box>
            </Stack.Item>
            <Stack.Item>
              <Button
                icon="box"
                disabled={
                  selected.some((recipe) => !recipe.available) ||
                  orderTotal > points ||
                  quantity > data.warehouse_shipment_limit
                }
                onClick={() => {
                  act('request_industry_order', {
                    items: Object.fromEntries(selected.map((recipe) => [recipe.id, draft[recipe.id]])),
                    revision: industry.revision,
                  });
                  setDraft({});
                  setChoosing(false);
                  setCategory(null);
                  setMaterial(null);
                  setSearch('');
                  setPage(0);
                }}>
                Заказать
              </Button>
            </Stack.Item>
          </Stack>
        </div>
      )}
    </div>
  );
};

type ShipmentItems = Record<string, number>;

const getShipment = (
  warehouse: WarehouseItem[],
  draft: ShipmentItems,
  limit: number,
) => {
  const items: ShipmentItems = {};
  let quantity = 0;
  for (const row of warehouse) {
    const selected = Math.min(
      draft[row.id] ?? 0,
      row.quantity,
      limit - quantity,
    );
    if (selected > 0) {
      items[row.id] = selected;
      quantity += selected;
    }
  }
  return { items, quantity };
};

const QuantityField = ({
  label,
  value,
  max,
  onChange,
  commitOnBlur = false,
}: {
  label: string;
  value: number;
  max: number;
  onChange: (amount: number) => void;
  commitOnBlur?: boolean;
}) => {
  const inputRef = useRef<HTMLInputElement>(null);
  const [editing, setEditing] = useState<string | null>(null);

  useEffect(() => {
    const input = inputRef.current;
    if (!input || !max) {
      return;
    }
    const adjustQuantity = (event: WheelEvent) => {
      if (!event.deltaY || event.ctrlKey) {
        return;
      }
      event.preventDefault();
      setEditing(null);
      const amount = Math.max(0, Math.min(value - Math.sign(event.deltaY), max));
      if (amount !== value) {
        onChange(amount);
      }
    };
    input.addEventListener('wheel', adjustQuantity, { passive: false });
    return () => input.removeEventListener('wheel', adjustQuantity);
  }, [max, onChange, value]);

  const commit = (text: string) => {
    const amount = Math.max(0, Math.min(Math.round(Number(text)), max));
    if (Number.isFinite(amount) && amount !== value) {
      onChange(amount);
    }
  };

  return (
    <input
      aria-label={label}
      ref={inputRef}
      type="number"
      inputMode="numeric"
      min={0}
      max={max}
      step={1}
      disabled={!max}
      value={editing ?? value}
      onFocus={(event) => event.currentTarget.select()}
      onChange={(event) => {
        const text = event.currentTarget.value;
        setEditing(text);
        if (!commitOnBlur) {
          commit(text);
        }
      }}
      onBlur={() => {
        if (commitOnBlur && editing !== null) {
          commit(editing);
        }
        setEditing(null);
      }}
      onKeyDown={(event) => {
        if (event.key === 'Enter') {
          event.currentTarget.blur();
        }
      }}
      style={{
        background: 'rgba(13,8,4,0.72)',
        border: tableBorder,
        borderRadius: '4px',
        boxSizing: 'border-box',
        color: '#f0dfc0',
        font: 'inherit',
        fontVariantNumeric: 'tabular-nums',
        height: '25px',
        padding: '1px 4px',
        textAlign: 'right',
        width: '4.5em',
      }}
    />
  );
};

const warehouseRow: React.CSSProperties = {
  alignItems: 'center',
  display: 'grid',
  gridTemplateColumns: 'minmax(0, 1fr) 5.5em 4.5em',
  gap: '10px',
  minHeight: '32px',
  borderBottom: tableBorder,
};

const ManorWarehouse = ({ active }: { active: boolean }) => {
  const { act, data } = useBackend<ManorPanelData>();
  const {
    warehouse,
    warehouse_raw_sale,
    warehouse_processed_sale,
    warehouse_revision,
    warehouse_shipment_limit,
  } = data;
  const [draft, setDraft] = useState<{ revision: number; items: ShipmentItems }>({
    revision: warehouse_revision,
    items: {},
  });
  const rows = useMemo(
    () => [...(warehouse ?? [])].sort((a, b) => a.name.localeCompare(b.name)),
    [warehouse],
  );
  const { items, quantity } = getShipment(
    rows,
    draft.items,
    warehouse_shipment_limit,
  );

  if (draft.revision !== warehouse_revision) {
    setDraft({ revision: warehouse_revision, items });
  }

  if (!active) {
    return null;
  }

  return (
    <div style={{ ...tablePanel, maxWidth: '31em' }}>
      <div
        style={{
          alignItems: 'center',
          display: 'grid',
          gridTemplateColumns: '1fr auto',
          gap: '4px 10px',
          marginBottom: '8px',
        }}>
        {([
          { stage: 'raw', label: 'Продавать сырьё', value: warehouse_raw_sale },
          { stage: 'processed', label: 'Продавать переработанное', value: warehouse_processed_sale },
        ] as const).map(({ stage, label, value }) => (
          <div key={stage} style={{ display: 'contents' }}>
            <Box bold>{label}</Box>
            <span>
              <QuantityField
                label={label}
                commitOnBlur
                max={100}
                value={value}
                onChange={(percent) => act('set_warehouse_sale', { stage, percent })}
              /> %
            </span>
          </div>
        ))}
      </div>

      {rows.length > 0 ? (
        <>
          <div style={{ ...warehouseRow, color: '#ceb38b', borderTop: tableBorder }}>
            <span>Товар</span>
            <span style={{ textAlign: 'right' }}>На складе</span>
            <span style={{ textAlign: 'center' }}>В заказ</span>
          </div>
          {rows.map((row) => {
            const selected = items[row.id] ?? 0;
            const maximum = Math.min(
              row.quantity,
              warehouse_shipment_limit - quantity + selected,
            );
            return (
              <div key={row.id} style={warehouseRow}>
                <span>{row.name}</span>
                <span style={{ textAlign: 'right', fontVariantNumeric: 'tabular-nums' }}>
                  {row.quantity}
                </span>
                <QuantityField
                  label={`${row.name}, количество в заказе`}
                  max={maximum}
                  value={selected}
                  onChange={(amount) =>
                    setDraft({
                      revision: warehouse_revision,
                      items: { ...items, [row.id]: amount },
                    })
                  }
                />
              </div>
            );
          })}
          <Stack align="center" mt={1} justify="space-between" wrap>
            <Stack.Item>Выбрано {quantity} из {warehouse_shipment_limit}</Stack.Item>
            <Stack.Item>
              <Button
                icon="box"
                disabled={!quantity}
                onClick={() => {
                  act('request_warehouse_shipment', {
                    items,
                    revision: warehouse_revision,
                  });
                  setDraft({ revision: warehouse_revision, items: {} });
                }}>
                Запросить поставку
              </Button>
            </Stack.Item>
          </Stack>
        </>
      ) : (
        <Box color="#ceb38b" py={1}>Склад пока пуст.</Box>
      )}
    </div>
  );
};

export const ManorPanel = () => {
  const { act, data } = useBackend<ManorPanelData>();
  const [hoveredItem, setHoveredItem] = useState<HoverCardData | null>(null);
  const [withdrawAmount, setWithdrawAmount] = useState(1);
  const [tab, setTab] = useState<'people' | 'warehouse' | 'workshop'>('people');
  const {
    manor_name,
    manor_type,
    manor_patron_key,
    manor_origin,
    total_workers,
    workers_assigned,
    estate_balance,
    estate_treasury_retention,
    estate_withdrawal_revision,
    industry,
    workstations = [],
  } = data;

  const production = industry?.active ? industry : undefined;
  const peasants = production?.peasants ?? total_workers;
  const artisans = production?.artisans ?? 0;
  const peasantsAssigned = production?.peasants_assigned ?? workers_assigned;
  const artisansAssigned = production?.artisans_assigned ?? 0;
  const maxWithdrawal = Math.floor(estate_balance ?? 0);

  return (
    <Window title={manor_name || 'Владение'} width={860} height={595}>
      <Window.Content scrollable style={panelBackground}>
        <div style={{ padding: '12px' }}>
          <div
            style={{
              ...frameStyle,
              alignItems: 'center',
              display: 'flex',
              flexWrap: 'wrap',
              justifyContent: 'space-between',
              gap: '10px 24px',
              padding: '8px 14px',
            }}>
            <Stack style={{ alignItems: 'center', gap: '12px' }}>
              <Stack.Item>
                <PatronMedallion patronKey={manor_patron_key} setHoveredItem={setHoveredItem} />
              </Stack.Item>
              <Stack.Item>
                <Box bold>{getManorType(manor_type)}</Box>
                {manor_origin && <Box color="#ceb38b">{manor_origin}</Box>}
              </Stack.Item>
            </Stack>
            {estate_balance != null && (
              <Stack style={{ alignItems: 'center', flexWrap: 'wrap', gap: '6px 10px' }}>
                <Stack.Item>
                  <Box bold>
                    Казна имения
                    <span style={{ marginLeft: '10px' }}>{estate_balance} маммон</span>
                  </Box>
                  <Box color="#ceb38b">В казне остаётся {estate_treasury_retention}% дохода</Box>
                </Stack.Item>
                {maxWithdrawal >= 1 && (
                  <>
                    <Stack.Item>
                      <NumberInput
                        minValue={0}
                        maxValue={maxWithdrawal}
                        step={1}
                        unit="м."
                        value={withdrawAmount}
                        width="5em"
                        onChange={setWithdrawAmount}
                      />
                    </Stack.Item>
                    <Stack.Item>
                      <Button
                        icon="coins"
                        disabled={
                          !Number.isInteger(withdrawAmount) ||
                          withdrawAmount < 1 ||
                          withdrawAmount > maxWithdrawal
                        }
                        onClick={() => {
                          act('withdraw_estate_money', {
                            amount: withdrawAmount,
                            revision: estate_withdrawal_revision,
                          });
                          setWithdrawAmount(1);
                        }}>
                        Запросить средства
                      </Button>
                    </Stack.Item>
                  </>
                )}
              </Stack>
            )}
          </div>

          {estate_balance != null && (
            <Tabs mt={1}>
              <Tabs.Tab
                selected={tab === 'people'}
                onClick={() => setTab('people')}
                icon="users"
              >
                Люди
              </Tabs.Tab>
              <Tabs.Tab
                selected={tab === 'warehouse'}
                onClick={() => setTab('warehouse')}
                icon="box"
              >
                Склад
              </Tabs.Tab>
              {!!industry?.active && (
                <Tabs.Tab
                  selected={tab === 'workshop'}
                  onClick={() => setTab('workshop')}
                  icon="hammer"
                >
                  Мастерские
                </Tabs.Tab>
              )}
            </Tabs>
          )}

          {tab === 'people' && (
            <>
              <div style={{ ...tablePanel, padding: '5px 16px' }}>
                <div style={{ display: 'grid', gridTemplateColumns: '7.5em auto', width: 'fit-content', gap: '4px 10px' }}>
                  <Box bold>Население</Box>
                  <Box bold>{peasantsAssigned + artisansAssigned}/{peasants + artisans}</Box>
                  <span>Крестьяне</span>
                  <span>{peasantsAssigned}/{peasants}</span>
                  <span>Ремесленники</span>
                  <span>{artisansAssigned}/{artisans}</span>
                </div>
              </div>
              <ManorWorkstations
                workstations={workstations}
                peasantsFree={peasants - peasantsAssigned}
                artisansFree={artisans - artisansAssigned}
                industry={production}
              />
            </>
          )}
          {estate_balance != null && <ManorWarehouse active={tab === 'warehouse'} />}
          {production && (
            <ManorWorkshop industry={production} active={tab === 'workshop'} />
          )}
        </div>
        <HoverCard data={hoveredItem} />
      </Window.Content>
    </Window>
  );
};
