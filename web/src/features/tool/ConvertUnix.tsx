import moment from 'moment';
import { fetchNui } from '../../utils/fetchNui';
import { useNuiEvent } from '../../hooks/useNuiEvent';
import type { ConvertUnix } from '../../typings/tool/ConvertUnix';

const ConvertUnixTime = () => {
  useNuiEvent('supv:convert:unix', (data: ConvertUnix) => {
    const unixTime: number = moment.duration(data.unix_time, 'milliseconds').as('seconds');
    const date: any|string = moment.unix(unixTime).format(data.format_date);
    fetchNui('supv:convert:return-unix', date);
  });

  return (
    <div>
      <p>Convert Unix Time</p>
    </div>
  );
};

export default ConvertUnixTime;